
begin tran tom

/*Deleting old translationID and updating to new matched record tbl_CCPlateConnector_L exengID:34*/
delete from [tbl_Translations] where TranslationID = 14 and FKTabID = 34
update [tbl_Translations] set TranslationID = 14 where TranslationID = 15 and FKTabID = 34 /* XLR */
delete from [tbl_Translations] where TranslationID = 15 and FKTabID = 34
update [tbl_Translations] set TranslationID = 15 where TranslationID = 16 and FKTabID = 34 /* USB */
delete from [tbl_Translations] where TranslationID = 16 and FKTabID = 34
update [tbl_Translations] set TranslationID = 16 where TranslationID = 17 and FKTabID = 34 /* Neutrik Speakon */
delete from [tbl_Translations] where TranslationID = 18 and FKTabID = 34
update [tbl_Translations] set TranslationID = 18 where TranslationID = 21 and FKTabID = 34 /* AC Power */
delete from [tbl_Translations] where TranslationID = 19 and FKTabID = 34
update [tbl_Translations] set TranslationID = 19 where TranslationID = 22 and FKTabID = 34 /* Fiber */
delete from [tbl_Translations] where TranslationID = 20 and FKTabID = 34
update [tbl_Translations] set TranslationID = 20 where TranslationID = 24 and FKTabID = 34 /* DVI */
delete from [tbl_Translations] where TranslationID = 21 and FKTabID = 34
update [tbl_Translations] set TranslationID = 21 where TranslationID = 25 and FKTabID = 34 /* HDMI */
delete from [tbl_Translations] where TranslationID = 22 and FKTabID = 34
update [tbl_Translations] set TranslationID = 22 where TranslationID = 26 and FKTabID = 34 /* DisplayPort */

/*Deleting old translationID and updating to new matched record tbl_CCPlateSignal_L exengID:35*/

delete from [tbl_Translations] where TranslationID = 6 and FKTabID = 35
update [tbl_Translations] set TranslationID = 6 where TranslationID = 7 and FKTabID = 35 /* Computer */
delete from [tbl_Translations] where TranslationID = 7 and FKTabID = 35
update [tbl_Translations] set TranslationID = 7 where TranslationID = 8 and FKTabID = 35 /* Buttons & Switches */
delete from [tbl_Translations] where TranslationID = 8 and FKTabID = 35
update [tbl_Translations] set TranslationID = 8 where TranslationID = 15 and FKTabID = 35 /* Interfaces */
delete from [tbl_Translations] where TranslationID = 9 and FKTabID = 35
update [tbl_Translations] set TranslationID = 9 where TranslationID = 22 and FKTabID = 35 /* RCM */
delete from [tbl_Translations] where TranslationID = 11 and FKTabID = 35
update [tbl_Translations] set TranslationID = 11 where TranslationID = 24 and FKTabID = 35 /* Fiber */
delete from [tbl_Translations] where TranslationID = 13 and FKTabID = 35
update [tbl_Translations] set TranslationID = 13 where TranslationID = 18 and FKTabID = 35 /* DVI */

/* Deleting all irrelevant translations. These no longer get used and will interfere with the new [tbl_CCPlateSignal_L]*/
delete from [tbl_Translations] where TranslationID = 10 and FKTabID = 35
delete from [tbl_Translations] where TranslationID = 12 and FKTabID = 35
delete from [tbl_Translations] where TranslationID = 14 and FKTabID = 35
delete from [tbl_Translations] where TranslationID = 15 and FKTabID = 35
delete from [tbl_Translations] where TranslationID = 16 and FKTabID = 35
delete from [tbl_Translations] where TranslationID = 17 and FKTabID = 35
delete from [tbl_Translations] where TranslationID = 18 and FKTabID = 35
delete from [tbl_Translations] where TranslationID = 19 and FKTabID = 35
delete from [tbl_Translations] where TranslationID = 20 and FKTabID = 35
delete from [tbl_Translations] where TranslationID = 21 and FKTabID = 35
delete from [tbl_Translations] where TranslationID = 22 and FKTabID = 35
delete from [tbl_Translations] where TranslationID = 23 and FKTabID = 35
delete from [tbl_Translations] where TranslationID = 24 and FKTabID = 35
delete from [tbl_Translations] where TranslationID = 25 and FKTabID = 35
delete from [tbl_Translations] where TranslationID = 26 and FKTabID = 35
delete from [tbl_Translations] where TranslationID = 27 and FKTabID = 35


select * from [tbl_Translations] where FKTabID = 35 and TranslationID = 13

rollback tran tom

commit tran tom
