-- ==========================================
-- ULTIMATE FIX - DISABLE RLS SEMENTARA
-- ==========================================
-- Cara paling pasti: Matikan RLS dulu untuk testing
-- Setelah berhasil, kita aktifkan lagi dengan policy yang benar

-- Matikan RLS
ALTER TABLE contact_messages DISABLE ROW LEVEL SECURITY;

-- Test dulu apakah contact form bisa submit
-- Kalau sudah berhasil, jalankan script di bawah ini:

/*
-- ==========================================
-- SETELAH TEST BERHASIL, JALANKAN INI:
-- ==========================================

-- Enable RLS kembali
ALTER TABLE contact_messages ENABLE ROW LEVEL SECURITY;

-- Hapus semua policy lama
DO $$ 
DECLARE
    pol record;
BEGIN
    FOR pol IN 
        SELECT policyname 
        FROM pg_policies 
        WHERE tablename = 'contact_messages'
    LOOP
        EXECUTE format('DROP POLICY IF EXISTS %I ON contact_messages', pol.policyname);
    END LOOP;
END $$;

-- Buat policy baru yang SIMPLE dan PASTI WORK
CREATE POLICY "allow_insert" ON contact_messages FOR INSERT WITH CHECK (true);
CREATE POLICY "allow_select" ON contact_messages FOR SELECT TO authenticated USING (EXISTS (SELECT 1 FROM admin_users WHERE admin_users.email = auth.jwt() ->> 'email'));
CREATE POLICY "allow_update" ON contact_messages FOR UPDATE TO authenticated USING (EXISTS (SELECT 1 FROM admin_users WHERE admin_users.email = auth.jwt() ->> 'email'));
CREATE POLICY "allow_delete" ON contact_messages FOR DELETE TO authenticated USING (EXISTS (SELECT 1 FROM admin_users WHERE admin_users.email = auth.jwt() ->> 'email'));

-- Verify
SELECT policyname, cmd FROM pg_policies WHERE tablename = 'contact_messages';
*/
