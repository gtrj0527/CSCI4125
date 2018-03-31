-- Query #15
-- has_skills / ks_code
-- has_cert / cert_code
CREATE VIEW skill_qual AS SELECT DISTINCT pers_id FROM has_skills AS hs1
WHERE NOT EXISTS
      (SELECT * FROM position_skills AS ps1
       WHERE pos_code = ? AND NOT EXISTS
          (SELECT * FROM has_skills AS hs2
           WHERE hs1.pers_id = hs2.pers_id AND
                 hs2.ks_code = ps1.ks_code));
CREATE VIEW cert_qual AS SELECT DISTINCT pers_id FROM has_cert AS hc1
WHERE NOT EXISTS
      (SELECT * FROM position_cert AS pc1
       WHERE pos_code = ? AND NOT EXISTS
          (SELECT * FROM has_cert AS hc2
           WHERE hc1.pers_id = hc2.pers_id AND
                 hc2.cert_code = pc1.cert_code));
                 
SELECT last_name, first_name, mi, email FROM person NATURAL JOIN skill_qual 
                                                    NATURAL JOIN cert_qual;
