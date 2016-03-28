-------------------------------------------                                                                                                                                                         
CREATE OR REPLACE FUNCTION classify_road(type VARCHAR) RETURNS TEXT
AS $$
BEGIN                                                                                                                                                                          
    RETURN CASE                                                                                                                                                                
            WHEN type IN ('funicular','light_rail','preserved','tram','disused','yard') THEN 'minor_rail'                                                                      
            WHEN type IN ('service','track','alley','spur','siding','crossover') THEN 'service'                                                                                
            WHEN type IN ('rail','monorail','narrow_gauge','subway') THEN 'major_rail'                                                                                         
            WHEN type IN ('driveway') THEN 'driveway'                                                                                                                          
            WHEN type IN ('path','cycleway','ski','steps','bridleway','footway') THEN 'path'                                                                                   
            WHEN type IN ('pedestrian','construction','private') THEN 'street_limited'                                                                                         
            WHEN type IN ('chair_lift','mixed_lift','drag_lift','platter','t-bar','magic_carpet','gondola','cable_car','rope_tow','zip_line','j-bar','canopy') THEN 'aerialway'
            WHEN type IN ('residential','unclassified','living_street','road','raceway') THEN 'street'                                                                         
            WHEN type IN ('motorway') THEN 'motorway'                                                                                                                          
            WHEN type IN ('hole') THEN 'golf'                                                                                                                                  
            WHEN type IN ('primary','primary_link','trunk','trunk_link','secondary','secondary_link','tertiary','tertiary_link') THEN 'main'                                   
            WHEN type IN ('motorway_link') THEN 'motorway_link'                                                                                                                
    END;                                                                                                                                                                       
END;      
$$ LANGUAGE plpgsql IMMUTABLE;

-------------------------------------------                                                                                                                                                         
CREATE OR REPLACE FUNCTION classify_landuse(type VARCHAR) RETURNS TEXT
AS $$
BEGIN                                                                                                                                                                          
     RETURN CASE                                                                                                                                                                
             WHEN type IN ('wetland','swamp','bog','marsh') THEN 'wetland'                                                                                                      
             WHEN type IN ('park','dog_park','common','garden','golf_course','playground','recreation_ground','nature_reserve',
                           'national_park','village_green','zoo','sports_centre','camp_site') THEN 'park'
             WHEN type IN ('sand') THEN 'sand'                                                                                                                                  
             WHEN type IN ('mud','tidalflat') THEN 'wetland_noveg'                                                                                                              
             WHEN type IN ('grass','grassland','meadow') THEN 'grass'                                                                                                           
             WHEN type IN ('industrial') THEN 'industrial'                                                                                                                      
             WHEN type IN ('athletics','chess','pitch') THEN 'pitch'                                                                                                            
             WHEN type IN ('school','college','university') THEN 'school'                                                                                                       
             WHEN type IN ('orchard','farm','farmland','farmyard','allotments','vineyard','plant_nursery') THEN 'agriculture'                                                   
             WHEN type IN ('hospital') THEN 'hospital'                                                                                                                          
             WHEN type IN ('wood','forest') THEN 'wood'                                                                                                                         
             WHEN type IN ('glacier') THEN 'glacier'                                                                                                                            
             WHEN type IN ('scrub') THEN 'scrub'                                                                                                                                
             WHEN type IN ('cemetery','christian','jewish') THEN 'cemetery'                                                                                                     
     END;                                                                                                                                                                       
 END;         
$$ LANGUAGE plpgsql IMMUTABLE;
