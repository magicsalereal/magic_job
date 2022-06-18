INSERT INTO `addon_account` (name, label, shared) VALUES
  ('society_magic', 'magic', 1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
  ('society_magic', 'magic', 1),
  ('society_magic_fridge', 'magic (fridge)', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES 
    ('society_magic', 'magic', 1)
;

INSERT INTO `jobs` (name, label) VALUES
  ('magic', 'magic')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
  ('magic', 0, 'barman', 'cybertender', 300, '{}', '{}'),
  ('magic', 1, 'dancer', 'Dancer', 300, '{}', '{}'),
  ('magic', 2, 'viceboss', 'Co-Manager', 500, '{}', '{}'),
  ('magic', 3, 'boss', 'Manager', 600, '{}', '{}')
;


