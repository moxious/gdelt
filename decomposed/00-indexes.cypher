CREATE INDEX entity_code FOR (e:Entity) ON (e.code);

CREATE CONSTRAINT event_id ON (e:Event) ASSERT e.id IS UNIQUE;
CREATE CONSTRAINT adm_code ON (a:AdministrativeRegion) ASSERT a.code IS UNIQUE;
CREATE CONSTRAINT country_iso2 ON (c:Country) ASSERT c.iso2 IS UNIQUE;
CREATE CONSTRAINT person_name on (p:Person) ASSERT p.name IS UNIQUE;
CREATE CONSTRAINT document_name ON (d:Document) ASSERT d.name IS UNIQUE;
CREATE CONSTRAINT source_name ON (s:Source) ASSERT s.name IS UNIQUE;
CREATE INDEX location_id FOR (l:Location) ON (l.id);
CREATE INDEX location_type FOR (l:Location) ON (l.type);
CREATE INDEX location_name FOR (l:Location) ON (l.name);
CREATE CONSTRAINT organization_name ON (o:Organization) ASSERT o.name IS UNIQUE;
CREATE CONSTRAINT theme_name ON (t:Theme) ASSERT t.name IS UNIQUE;

CREATE INDEX count_type FOR (c:Count) ON (c.type);
CREATE INDEX count_number FOR (c:Count) ON (c.number);
CREATE INDEX count_id FOR (c:Count) ON (c.id);