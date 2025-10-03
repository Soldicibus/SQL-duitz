CREATE OR REPLACE FUNCTION get_top_math_students(class_name VARCHAR)
RETURNS TABLE(
    student_id INT,
    student_name VARCHAR(50),
    student_surname VARCHAR(50),
    avg_mark NUMERIC
) 
AS $$
BEGIN
  RETURN QUERY
  SELECT st.student_id, st.student_name, st.student_surname, AVG(j.journal_mark)::NUMERIC
  FROM student st
  JOIN journal j ON st.student_id = j.journal_student_id
  JOIN timetable t ON j.journal_time_id = t.time_id
  WHERE st.student_class = class_name
    AND t.time_subject_name = 'Математика'
  GROUP BY st.student_id, st.student_name, st.student_surname
  HAVING AVG(j.journal_mark) > 74;
END;
$$ LANGUAGE plpgsql;
