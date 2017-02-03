<?xml version="1.0" encoding="UTF-8"?>
<!-- ====================================================
     XML Construct Domain Module
    
     Author: your name here

     Copyright (c) 2011 copyright holder
     
     license to use or not use or whatever
          
     ==================================================== -->

<!-- ============================================================= -->
<!--                   ELEMENT NAME ENTITIES                       -->
<!-- ============================================================= -->

<!ENTITY % xmlelem "xmlelem"  >
<!ENTITY % textent "textent"  >     
<!ENTITY % parment "parment"  >

<!-- ============================================================= -->
<!--                    ELEMENT DECLARATIONS                       -->
<!-- ============================================================= -->


<!--                    LONG NAME: XML Element                            -->
<!ENTITY % xmlelem.content 
  " 
  (#PCDATA)*
  "
>
<!ENTITY % xmlelem.attributes
  '
  %univ-atts;          
  keyref
    CDATA
    #IMPLIED
  outputclass 
    CDATA
    #IMPLIED    
  '
>
<!ELEMENT xmlelem %xmlelem.content; >
<!ATTLIST xmlelem %xmlelem.attributes; >

<!--                    LONG NAME: Text entity -->
<!ENTITY % textent.content 
  " 
  (#PCDATA)*
  "
>
<!ENTITY % textent.attributes
  '
  %univ-atts;          
  keyref
    CDATA
    #IMPLIED
  outputclass 
    CDATA
    #IMPLIED    
  '
>
<!ELEMENT textent %textent.content; >
<!ATTLIST textent %textent.attributes; >

<!--                    LONG NAME: Parameter entity -->
<!ENTITY % parment.content 
  " 
  (#PCDATA)*
  "
>
<!ENTITY % parment.attributes
  '
  %univ-atts;          
  keyref
    CDATA
    #IMPLIED
  outputclass 
    CDATA
    #IMPLIED    
  '
>
<!ELEMENT parment %parment.content; >
<!ATTLIST parment %parment.attributes; >

<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->


<!ATTLIST xmlelem     %global-atts;  class CDATA "+ topic/keyword xml1-d/xmlelem "  >
<!ATTLIST textent     %global-atts;  class CDATA "+ topic/keyword xml1-d/textent "  >
<!ATTLIST parment     %global-atts;  class CDATA "+ topic/keyword xml1-d/parment "  >


<!-- ================== End XML Domain ==================== -->

