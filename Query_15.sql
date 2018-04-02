-- Query #15
-- has_skills / ks_code
-- has_cert / cert_code

INSERT INTO has_skill VALUES (1, 'Java2');

DROP VIEW skill_qual;
CREATE VIEW skill_qual AS SELECT DISTINCT pers_id FROM has_skill hs1
WHERE NOT EXISTS
      (SELECT * FROM position_skills ps1
       WHERE pos_code = 10 AND NOT EXISTS
          (SELECT * FROM has_skill hs2
           WHERE hs1.pers_id = hs2.pers_id AND
                 hs2.ks_code = ps1.ks_code));
DROP VIEW cert_qual;
CREATE VIEW cert_qual AS SELECT DISTINCT pers_id FROM has_cert hc1
WHERE NOT EXISTS
      (SELECT * FROM position_cert pc1
       WHERE pos_code = 10 AND NOT EXISTS
          (SELECT * FROM has_cert hc2
           WHERE hc1.pers_id = hc2.pers_id AND
                 hc2.cert_code = pc1.cert_code));
                 
SELECT last_name, first_name, mi, email FROM person NATURAL JOIN skill_qual; 
                                                    --NATURAL JOIN cert_qual;
