CREATE CONSTRAINT event_id ON (e:Event) ASSERT e.id IS UNIQUE;

create index on :Entity(code);
create index on :GCAMVariable(id);

CREATE INDEX ON :Event(id);
CREATE INDEX ON :Theme(name);
CREATE INDEX ON :Organization(name);
CREATE INDEX ON :Person(name);
CREATE INDEX ON :Source(name);
CREATE INDEX ON :Location(name);

CREATE INDEX ON :GCAMScore(value);