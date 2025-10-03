CREATE OR REPLACE FUNCTION get_avg_attendance_for_month(target_month INT, target_year INT)
RETURNS TABLE(class_name VARCHAR, avg_attendance NUMERIC) AS $$
BEGIN
    RETURN QUERY
    SELECT
        st.student_class AS class_name,
        ROUND(
            AVG(
                CASE 
                    WHEN j.journal_status IN ('П', 'Присутній') THEN 1
                    ELSE 0
                END
            ) * 100, 2
        ) AS avg_attendance
    FROM journal j
    JOIN student st ON j.journal_student_id = st.student_id
    JOIN timetable t ON j.journal_time_id = t.time_id
    WHERE EXTRACT(MONTH FROM j.journal_date) = target_month
      AND EXTRACT(YEAR FROM j.journal_date) = target_year
    GROUP BY st.student_class;
END;
$$ LANGUAGE plpgsql;
