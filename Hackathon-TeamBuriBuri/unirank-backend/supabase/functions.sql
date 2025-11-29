CREATE OR REPLACE FUNCTION calculate_pro_score(student_uuid UUID)
RETURNS VOID AS $$
DECLARE
    v_attendance INT;
    v_project_count INT;
    v_cert_count INT;
    v_new_score INT;
BEGIN
    -- Get attendance
    SELECT attendance INTO v_attendance FROM students WHERE id = student_uuid;
    
    -- Get project count
    SELECT COUNT(*) INTO v_project_count FROM projects WHERE student_id = student_uuid;
    
    -- Get cert count (using skills array length as proxy)
    SELECT array_length(skills, 1) INTO v_cert_count FROM students WHERE id = student_uuid;
    IF v_cert_count IS NULL THEN
        v_cert_count := 0;
    END IF;

    -- Calculate Score
    -- Formula: (attendance * 0.4) + (project_count * 4) + (cert_count * 2)
    v_new_score := (v_attendance * 0.4) + (v_project_count * 4) + (v_cert_count * 2);

    -- Update student record
    UPDATE students SET pro_score = v_new_score WHERE id = student_uuid;
END;
$$ LANGUAGE plpgsql;
