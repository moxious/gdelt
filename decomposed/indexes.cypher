CREATE CONSTRAINT event_id ON (e:Event) ASSERT e.id IS UNIQUE;
CREATE CONSTRAINT adm_code ON (a:AdministrativeRegion) ASSERT a.code IS UNIQUE;
CREATE CONSTRAINT gdeltcountry_iso2 ON (c:GDELTCountry) ASSERT c.iso2 IS UNIQUE;
CREATE CONSTRAINT person_name on (p:Person) ASSERT p.name IS UNIQUE;
CREATE CONSTRAINT document_name ON (d:Document) ASSERT d.name IS UNIQUE;
CREATE CONSTRAINT source_name ON (s:Source) ASSERT s.name IS UNIQUE;
CREATE INDEX location_type FOR (l:Location) ON (l.type);
CREATE INDEX location_name FOR (l:Location) ON (l.name);
CREATE CONSTRAINT organization_name ON (o:Organization) ASSERT o.name IS UNIQUE;
CREATE CONSTRAINT theme_name ON (t:Theme) ASSERT t.name IS UNIQUE;

FOR (n:LabelName)
ON (n.propertyName)

create index on :Entity(code);
create index on :GCAMVariable(id);

CREATE INDEX ON :Event(id);
CREATE INDEX ON :Theme(name);
CREATE INDEX ON :Organization(name);
CREATE INDEX ON :Person(name);
CREATE INDEX ON :Source(name);
CREATE INDEX ON :Location(name);

CREATE INDEX ON :GCAMScore(value);