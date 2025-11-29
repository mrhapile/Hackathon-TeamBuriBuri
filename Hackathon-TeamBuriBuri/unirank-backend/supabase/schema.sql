-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Table: students
CREATE TABLE students (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    auth_id UUID UNIQUE,
    name TEXT,
    email TEXT UNIQUE,
    avatar_url TEXT,
    college TEXT,
    branch TEXT,
    year INT,
    pro_score INT DEFAULT 0,
    social_score INT DEFAULT 0,
    attendance INT DEFAULT 0,
    gpa FLOAT DEFAULT 0,
    skills TEXT[] DEFAULT '{}',
    lc_id TEXT,
    cf_id TEXT,
    cc_id TEXT,
    github_username TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Table: projects
CREATE TABLE projects (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    student_id UUID REFERENCES students(id) ON DELETE CASCADE,
    title TEXT,
    description TEXT,
    repo_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Table: social_testimonials
CREATE TABLE social_testimonials (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    student_id UUID REFERENCES students(id) ON DELETE CASCADE,
    quote TEXT,
    designation TEXT,
    image_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Table: leaderboard_cache (optional optimization)
CREATE TABLE leaderboard_cache (
    id SERIAL PRIMARY KEY,
    college TEXT,
    top_students JSONB,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
