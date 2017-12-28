CREATE TABLE "checklists" (
      "id" SERIAL PRIMARY KEY,
      "title" TEXT
);

insert into checklists (title) values
('backend'),
('shopping');

CREATE TABLE "checklistitems" (
      "id" SERIAL PRIMARY KEY,
      "name" TEXT NOT NULL,
      "finished" BOOLEAN NOT NULL,
      "checklist" INTEGER NOT NULL
);

insert into checklistitems (name, finished, checklist) values
('reformat code', true, 1),
('user login', true, 1),
('add CI', false, 1),
('tomato', false, 2),
('potato', false, 2);
