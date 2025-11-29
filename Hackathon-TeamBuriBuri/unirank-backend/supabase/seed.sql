-- Seed Colleges
WITH colleges AS (
    SELECT unnest(ARRAY[
        'IIT Bombay', 'IIT Delhi', 'BITS Pilani', 'NIT Trichy', 'Anna University',
        'VIT Vellore', 'SRM University', 'Manipal Institute of Technology', 'IIIT Hyderabad', 'DTU'
    ]) AS name
)
INSERT INTO leaderboard_cache (college) SELECT name FROM colleges;

-- Seed Students (Generating 50 random students)
INSERT INTO students (auth_id, name, email, college, branch, year, attendance, gpa, skills, github_username, lc_id, cf_id)
SELECT
    uuid_generate_v4(),
    'Student ' || generate_series,
    'student' || generate_series || '@example.com',
    (ARRAY['IIT Bombay', 'IIT Delhi', 'BITS Pilani', 'NIT Trichy', 'Anna University', 'VIT Vellore', 'SRM University', 'Manipal Institute of Technology', 'IIIT Hyderabad', 'DTU'])[floor(random() * 10 + 1)],
    (ARRAY['CSE', 'ECE', 'MECH', 'EEE', 'CIVIL'])[floor(random() * 5 + 1)],
    floor(random() * 4 + 1)::int,
    floor(random() * 40 + 60)::int, -- Attendance 60-100
    (random() * 4 + 6)::numeric(3,1), -- GPA 6.0-10.0
    ARRAY['React', 'Node.js', 'Python', 'Java', 'C++'][1:floor(random() * 5 + 1)],
    'user' || generate_series,
    'lc_user' || generate_series,
    'cf_user' || generate_series
FROM generate_series(1, 50);

-- Seed Projects
INSERT INTO projects (student_id, title, description, repo_url)
SELECT
    id,
    'Project ' || generate_series,
    'A cool project about ' || (ARRAY['AI', 'Web', 'Blockchain', 'IoT', 'Cloud'])[floor(random() * 5 + 1)],
    'https://github.com/user/repo' || generate_series
FROM students
CROSS JOIN generate_series(1, 2) -- 2 projects per student
WHERE random() > 0.3; -- 70% chance of having projects

-- Seed Testimonials
INSERT INTO social_testimonials (student_id, quote, designation, image_url)
SELECT
    id,
    'This platform helped me get noticed by top recruiters!',
    'SDE @ Google',
    'https://i.pravatar.cc/150?u=' || id
FROM students
WHERE random() > 0.9 -- 10% of students have testimonials
LIMIT 5;

-- Calculate Initial Scores
DO $$
DECLARE
    s RECORD;
BEGIN
    FOR s IN SELECT id FROM students LOOP
        PERFORM calculate_pro_score(s.id);
    END LOOP;
END $$;
