public class ProgramEnrollmentTriggerHandler extends TriggerHandler {
    public override void afterUpdate() {
        shareProgramEnrollment(Trigger.new, (Map<Id, Program_Enrollment__c>)Trigger.OldMap);
    }

    public override void afterInsert() {
        shareProgramEnrollment(Trigger.new, null);
    }

    public static void shareProgramEnrollment(List<Program_Enrollment__c> triggerNew, Map<Id, Program_Enrollment__c> oldMap){
        List<Program_Enrollment__Share> progs = new List<Program_Enrollment__Share>();
        List<Group> OdesaDirectorGroup = [SELECT Id FROM Group WHERE Type = 'Role' AND DeveloperName = 'Odesa_Director'];
        Id OdesaDirectorIdGroup = '';
        if(OdesaDirectorGroup.size() != 0) {
            OdesaDirectorIdGroup = OdesaDirectorGroup[0].Id;
        }
        List<Group> KyivAndSubordinateDirectorGroup = [SELECT Id FROM Group WHERE Type = 'RoleAndSubordinates' AND DeveloperName = 'Kyiv_Director'];
        Id KyivAndSubordinateDirectorIdGroup = '';
        if(KyivAndSubordinateDirectorGroup.size() != 0) {
            KyivAndSubordinateDirectorIdGroup = KyivAndSubordinateDirectorGroup[0].Id;
        }
        List<Group> LvivAndSubordinateDirectorGroup = [SELECT Id FROM Group WHERE Type = 'RoleAndSubordinates' AND DeveloperName = 'Lviv_Director'];
        Id LvivAndSubordinateDirectorIdGroup = '';
        if(LvivAndSubordinateDirectorGroup.size() != 0) {
            LvivAndSubordinateDirectorIdGroup = LvivAndSubordinateDirectorGroup[0].Id;
        }
        Set<Id> KyivAndSubordinatesUsersSetId = new Set<Id>();
        for(User u : [SELECT Id, Name, UserRole.Name FROM User WHERE UserRole.Name Like 'Kyiv %']){
            KyivAndSubordinatesUsersSetId.add(u.Id);
        }
        Set<Id> LvivAndSubordinatesUsersSetId = new Set<Id>();
        for(User u : [SELECT Id, Name, UserRole.Name FROM User WHERE UserRole.Name Like 'Lviv %']){
            LvivAndSubordinatesUsersSetId.add(u.Id);
        }
        for(Program_Enrollment__c p : triggerNew){            
            if(p.city__c == 'Odesa' && OdesaDirectorIdGroup != '' && (oldMap == null || p.city__c != oldMap.get(p.Id).city__c)){
                Program_Enrollment__Share prog = new Program_Enrollment__Share();
                prog.ParentId = p.Id;
                prog.UserOrGroupId = OdesaDirectorIdGroup;
                prog.AccessLevel = 'edit';
                prog.RowCause = Schema.Program_Enrollment__Share.RowCause.OdesaDirector__c;
                progs.add(prog);
            } else if(KyivAndSubordinatesUsersSetId.contains(p.Owner.Id) && KyivAndSubordinateDirectorIdGroup != '' && (oldMap == null || p.OwnerId != oldMap.get(p.Id).OwnerId)){
                Program_Enrollment__Share prog = new Program_Enrollment__Share();
                prog.ParentId = p.Id;
                prog.UserOrGroupId = KyivAndSubordinateDirectorIdGroup;
                prog.AccessLevel = 'edit';
                prog.RowCause = Schema.Program_Enrollment__Share.RowCause.KyivDirector__c;
                progs.add(prog);
            }
            else if(LvivAndSubordinatesUsersSetId.contains(p.Owner.Id)  && LvivAndSubordinateDirectorIdGroup != '' && (oldMap == null || p.OwnerId != oldMap.get(p.Id).OwnerId)){
                Program_Enrollment__Share prog = new Program_Enrollment__Share();
                prog.ParentId = p.Id;
                prog.UserOrGroupId = LvivAndSubordinateDirectorIdGroup;
                prog.AccessLevel = 'edit';
                prog.RowCause = Schema.Program_Enrollment__Share.RowCause.LvivDirector__c;
                progs.add(prog);
            }
        } 
        Database.SaveResult[] jprogShareInsertResult = Database.insert(progs,false);
    }
}
