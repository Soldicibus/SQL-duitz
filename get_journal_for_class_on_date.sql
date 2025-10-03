CREATE OR REPLACE FUNCTION get_journal_for_class_on_date(class_arg VARCHAR, ref_date DATE DEFAULT CURRENT_DATE)
RETURNS TABLE(
    student_name VARCHAR(50),
    student_surname VARCHAR(50),
    total_absences BIGINT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        st.student_name,
        st.student_surname,
        COUNT(*) AS total_absences
    FROM journal j
    JOIN student st ON j.journal_student_id = st.student_id
    WHERE st.student_class = class_arg
      AND j.journal_status IN ('Н', 'Не присутній')
      AND j.journal_date BETWEEN (ref_date - INTERVAL '7 days') AND ref_date
    GROUP BY st.student_name, st.student_surname
    HAVING COUNT(*) > 2
    ORDER BY total_absences DESC;
END;
$$ LANGUAGE plpgsql;
