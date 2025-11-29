-- Enable RLS on all tables
ALTER TABLE students ENABLE ROW LEVEL SECURITY;
ALTER TABLE projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE social_testimonials ENABLE ROW LEVEL SECURITY;

-- Students Policies
-- Public can read student basic info
CREATE POLICY "Public can read students" ON students
    FOR SELECT USING (true);

-- Students can insert/update only their own row
CREATE POLICY "Students can update own profile" ON students
    FOR UPDATE USING (auth.uid() = auth_id);

CREATE POLICY "Students can insert own profile" ON students
    FOR INSERT WITH CHECK (auth.uid() = auth_id);

-- Projects Policies
-- Public can read projects
CREATE POLICY "Public can read projects" ON projects
    FOR SELECT USING (true);

-- Owner can add/update their own projects
CREATE POLICY "Students can insert own projects" ON projects
    FOR INSERT WITH CHECK (
        student_id IN (SELECT id FROM students WHERE auth_id = auth.uid())
    );

CREATE POLICY "Students can update own projects" ON projects
    FOR UPDATE USING (
        student_id IN (SELECT id FROM students WHERE auth_id = auth.uid())
    );

CREATE POLICY "Students can delete own projects" ON projects
    FOR DELETE USING (
        student_id IN (SELECT id FROM students WHERE auth_id = auth.uid())
    );

-- Testimonials Policies
-- Public can read testimonials
CREATE POLICY "Public can read testimonials" ON social_testimonials
    FOR SELECT USING (true);

-- Only admins or system can insert (assuming manual or system process for now, or open to all for demo)
-- For now, let's allow read-only for public, and maybe insert for authenticated users if needed, but prompt implies fetching.
-- Let's assume testimonials are managed by system or specific logic.
