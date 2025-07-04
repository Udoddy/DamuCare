-- DamuCare Blood Donation App - User Management Module
-- Migration: Initial user authentication and profile system

-- 1. Types and Enums
CREATE TYPE public.user_role AS ENUM ('admin', 'donor', 'center_staff');
CREATE TYPE public.blood_type AS ENUM ('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-');
CREATE TYPE public.eligibility_status AS ENUM ('eligible', 'not_eligible', 'pending_review');

-- 2. User Profiles Table (Critical intermediary for auth)
CREATE TABLE public.user_profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT NOT NULL UNIQUE,
    full_name TEXT NOT NULL,
    phone TEXT,
    role public.user_role DEFAULT 'donor'::public.user_role,
    blood_type public.blood_type,
    date_of_birth DATE,
    weight DECIMAL(5,2),
    location_city TEXT,
    location_region TEXT,
    emergency_contact_name TEXT,
    emergency_contact_phone TEXT,
    emergency_contact_relationship TEXT,
    preferred_language TEXT DEFAULT 'English',
    eligibility_status public.eligibility_status DEFAULT 'pending_review'::public.eligibility_status,
    last_eligibility_check TIMESTAMPTZ,
    profile_photo_url TEXT,
    notification_preferences JSONB DEFAULT '{"appointments": true, "eligibility": true, "educational": false, "impact": true}'::jsonb,
    app_preferences JSONB DEFAULT '{"offline_content": true, "data_usage": "wifi_only", "accessibility": false}'::jsonb,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 3. Donation Centers Table
CREATE TABLE public.donation_centers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    address TEXT NOT NULL,
    city TEXT NOT NULL,
    region TEXT NOT NULL,
    phone TEXT,
    email TEXT,
    latitude DECIMAL(10,8),
    longitude DECIMAL(11,8),
    operating_hours JSONB,
    facilities TEXT[],
    capacity_per_day INTEGER DEFAULT 50,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 4. Essential Indexes
CREATE INDEX idx_user_profiles_email ON public.user_profiles(email);
CREATE INDEX idx_user_profiles_role ON public.user_profiles(role);
CREATE INDEX idx_user_profiles_blood_type ON public.user_profiles(blood_type);
CREATE INDEX idx_user_profiles_eligibility ON public.user_profiles(eligibility_status);
CREATE INDEX idx_donation_centers_city ON public.donation_centers(city);
CREATE INDEX idx_donation_centers_active ON public.donation_centers(is_active);

-- 5. Enable RLS
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.donation_centers ENABLE ROW LEVEL SECURITY;

-- 6. Helper Functions for RLS
CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
SELECT EXISTS (
    SELECT 1 FROM public.user_profiles up
    WHERE up.id = auth.uid() AND up.role = 'admin'::public.user_role
)
$$;

CREATE OR REPLACE FUNCTION public.is_center_staff()
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
SELECT EXISTS (
    SELECT 1 FROM public.user_profiles up
    WHERE up.id = auth.uid() AND up.role = 'center_staff'::public.user_role
)
$$;

-- 7. Updated Timestamp Function
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;

-- 8. Triggers for Updated Timestamps
CREATE TRIGGER update_user_profiles_updated_at
    BEFORE UPDATE ON public.user_profiles
    FOR EACH ROW
    EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_donation_centers_updated_at
    BEFORE UPDATE ON public.donation_centers
    FOR EACH ROW
    EXECUTE FUNCTION public.update_updated_at_column();

-- 9. RLS Policies
CREATE POLICY "users_own_profile"
ON public.user_profiles
FOR ALL
TO authenticated
USING (auth.uid() = id)
WITH CHECK (auth.uid() = id);

CREATE POLICY "admins_manage_all_profiles"
ON public.user_profiles
FOR ALL
TO authenticated
USING (public.is_admin())
WITH CHECK (public.is_admin());

CREATE POLICY "donation_centers_public_read"
ON public.donation_centers
FOR SELECT
TO authenticated
USING (is_active = true);

CREATE POLICY "staff_manage_centers"
ON public.donation_centers
FOR ALL
TO authenticated
USING (public.is_center_staff() OR public.is_admin())
WITH CHECK (public.is_center_staff() OR public.is_admin());

-- 10. Function for automatic profile creation
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
SECURITY DEFINER
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO public.user_profiles (
        id, 
        email, 
        full_name, 
        role,
        preferred_language
    )
    VALUES (
        NEW.id, 
        NEW.email, 
        COALESCE(NEW.raw_user_meta_data->>'full_name', split_part(NEW.email, '@', 1)),
        COALESCE(NEW.raw_user_meta_data->>'role', 'donor')::public.user_role,
        COALESCE(NEW.raw_user_meta_data->>'preferred_language', 'English')
    );
    RETURN NEW;
END;
$$;

-- 11. Trigger for new user creation
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- 12. Mock Data for Development
DO $$
DECLARE
    admin_uuid UUID := gen_random_uuid();
    donor_uuid UUID := gen_random_uuid();
    staff_uuid UUID := gen_random_uuid();
    center1_uuid UUID := gen_random_uuid();
    center2_uuid UUID := gen_random_uuid();
BEGIN
    -- Create auth users with required fields
    INSERT INTO auth.users (
        id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
        created_at, updated_at, raw_user_meta_data, raw_app_meta_data,
        is_sso_user, is_anonymous, confirmation_token, confirmation_sent_at,
        recovery_token, recovery_sent_at, email_change_token_new, email_change,
        email_change_sent_at, email_change_token_current, email_change_confirm_status,
        reauthentication_token, reauthentication_sent_at, phone, phone_change,
        phone_change_token, phone_change_sent_at
    ) VALUES
        (admin_uuid, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
         'admin@damucare.co.tz', crypt('admin123', gen_salt('bf', 10)), now(), now(), now(),
         '{"full_name": "Admin User", "role": "admin"}'::jsonb, '{"provider": "email", "providers": ["email"]}'::jsonb,
         false, false, '', null, '', null, '', '', null, '', 0, '', null, null, '', '', null),
        (donor_uuid, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
         'lucy.mwangi@gmail.com', crypt('password123', gen_salt('bf', 10)), now(), now(), now(),
         '{"full_name": "Lucy Mwangi", "role": "donor"}'::jsonb, '{"provider": "email", "providers": ["email"]}'::jsonb,
         false, false, '', null, '', null, '', '', null, '', 0, '', null, null, '', '', null),
        (staff_uuid, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
         'staff@nbts.go.tz', crypt('staff123', gen_salt('bf', 10)), now(), now(), now(),
         '{"full_name": "Center Staff", "role": "center_staff"}'::jsonb, '{"provider": "email", "providers": ["email"]}'::jsonb,
         false, false, '', null, '', null, '', '', null, '', 0, '', null, null, '', '', null);

    -- Update user profiles with additional data
    UPDATE public.user_profiles 
    SET 
        phone = '+255 712 345 678',
        blood_type = 'O+'::public.blood_type,
        date_of_birth = '1999-03-15',
        weight = 55.5,
        location_city = 'Arusha',
        location_region = 'Arusha',
        emergency_contact_name = 'John Mwangi',
        emergency_contact_phone = '+255 712 987 654',
        emergency_contact_relationship = 'Brother',
        eligibility_status = 'eligible'::public.eligibility_status,
        profile_photo_url = 'https://images.unsplash.com/photo-1494790108755-2616b612b786?fm=jpg&q=60&w=400'
    WHERE email = 'lucy.mwangi@gmail.com';

    -- Create donation centers
    INSERT INTO public.donation_centers (id, name, address, city, region, phone, email, latitude, longitude, operating_hours, facilities) VALUES
        (center1_uuid, 'Arusha Regional Blood Bank', 'Kaloleni Road, Near AICC', 'Arusha', 'Arusha', '+255 27 254 4393', 'arbb@nbts.go.tz', -3.3869, 36.6830, 
         '{"monday": "08:00-16:00", "tuesday": "08:00-16:00", "wednesday": "08:00-16:00", "thursday": "08:00-16:00", "friday": "08:00-16:00", "saturday": "09:00-13:00", "sunday": "closed"}'::jsonb,
         ARRAY['parking', 'wheelchair_access', 'refreshments', 'wifi']),
        (center2_uuid, 'Muhimbili Blood Bank', 'Muhimbili Hospital', 'Dar es Salaam', 'Dar es Salaam', '+255 22 215 0302', 'muhimbili@nbts.go.tz', -6.8037, 39.2684,
         '{"monday": "07:00-17:00", "tuesday": "07:00-17:00", "wednesday": "07:00-17:00", "thursday": "07:00-17:00", "friday": "07:00-17:00", "saturday": "08:00-14:00", "sunday": "emergency_only"}'::jsonb,
         ARRAY['parking', 'wheelchair_access', 'refreshments', 'wifi', 'emergency_services']);

EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE NOTICE 'Foreign key error: %', SQLERRM;
    WHEN unique_violation THEN
        RAISE NOTICE 'Unique constraint error: %', SQLERRM;
    WHEN OTHERS THEN
        RAISE NOTICE 'Unexpected error: %', SQLERRM;
END $$;

-- 13. Cleanup function for development
CREATE OR REPLACE FUNCTION public.cleanup_test_data()
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    auth_user_ids_to_delete UUID[];
BEGIN
    -- Get auth user IDs for test accounts
    SELECT ARRAY_AGG(id) INTO auth_user_ids_to_delete
    FROM auth.users
    WHERE email IN ('admin@damucare.co.tz', 'lucy.mwangi@gmail.com', 'staff@nbts.go.tz');

    -- Delete in dependency order
    DELETE FROM public.donation_centers WHERE name LIKE '%Regional%' OR name LIKE '%Muhimbili%';
    DELETE FROM public.user_profiles WHERE id = ANY(auth_user_ids_to_delete);
    DELETE FROM auth.users WHERE id = ANY(auth_user_ids_to_delete);

EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE NOTICE 'Foreign key constraint prevents deletion: %', SQLERRM;
    WHEN OTHERS THEN
        RAISE NOTICE 'Cleanup failed: %', SQLERRM;
END;
$$;