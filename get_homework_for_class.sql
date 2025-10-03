CREATE OR REPLACE FUNCTION get_homework_for_class(class_name VARCHAR, day DATE)
RETURNS TABLE(
    homework_id INT,
    subject_name VARCHAR(30),
    description TEXT,
    due_date DATE
) 
AS $$
BEGIN
  RETURN QUERY
  SELECT h.homework_id, s.subject_name, h.homework_description, h.homework_date
  FROM homework h
  JOIN subject s ON h.homework_subject = s.subject_name
  WHERE h.homework_class = class_name
    AND h.homework_date = day + INTERVAL '1 day';
END;
$$ LANGUAGE plpgsql;
