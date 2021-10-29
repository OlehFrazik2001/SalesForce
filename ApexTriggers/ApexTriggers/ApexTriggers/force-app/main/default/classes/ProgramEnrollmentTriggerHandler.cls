public class ProgramEnrollmentTriggerHandler extends TriggerHandler {
    public override void afterUpdate() {
        shareProgramEnrollment(Trigger.new);
    }

    public override void afterInsert() {
        shareProgramEnrollment(Trigger.new);
    }

    public static void shareProgramEnrollment(List<Program_Enrollment__c> triggerNew){
        List<Program_Enrollment__Share> progs = new List<Program_Enrollment__Share>();
        Id OdesaDirectorIdGroup = [SELECT Id FROM Group WHERE Type = 'Role' AND DeveloperName = 'Odesa_Director'].Id;
        Id KyivAndSubordinateDirectorIdGroup = [SELECT Id FROM Group WHERE Type = 'RoleAndSubordinates' AND DeveloperName = 'Kyiv_Director'].Id;
        Id LvivAndSubordinateDirectorIdGroup = [SELECT Id FROM Group WHERE Type = 'RoleAndSubordinates' AND DeveloperName = 'Lviv_Director'].Id;
        Set<Id> KyivAndSubordinatesUsersSetId = new Set<Id>();
        for(User u : [SELECT Id, Name, UserRole.Name FROM User WHERE UserRole.Name Like 'Kyiv %']){
            KyivAndSubordinatesUsersSetId.add(u.Id);
        }
        Set<Id> LvivAndSubordinatesUsersSetId = new Set<Id>();
        for(User u : [SELECT Id, Name, UserRole.Name FROM User WHERE UserRole.Name Like 'Lviv %']){
            LvivAndSubordinatesUsersSetId.add(u.Id);
        }
        for(Program_Enrollment__c p : triggerNew){            
            if(p.city__c == 'Odesa'){
                Program_Enrollment__Share prog = new Program_Enrollment__Share();
                prog.ParentId = p.Id;
                prog.UserOrGroupId = OdesaDirectorIdGroup;
                prog.AccessLevel = 'edit';
                prog.RowCause = Schema.Program_Enrollment__Share.RowCause.OdesaDirector__c;
                progs.add(prog);
            } else if(KyivAndSubordinatesUsersSetId.contains(p.Owner.Id)){
                Program_Enrollment__Share prog = new Program_Enrollment__Share();
                prog.ParentId = p.Id;
                prog.UserOrGroupId = KyivAndSubordinateDirectorIdGroup;
                prog.AccessLevel = 'edit';
                prog.RowCause = Schema.Program_Enrollment__Share.RowCause.KyivDirector__c;
                progs.add(prog);
            }
            else if(LvivAndSubordinatesUsersSetId.contains(p.Owner.Id)){
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
