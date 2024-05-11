// These were originally hardcoded in the source code way back in 2021-2022 ...

#include "Utils.as"

bool IsValidCopForTargeting(CP3SObj@ self, CP3SObj@ Whom, CP3SObj@ targ)
{
	if ( @Whom == null )
		return false;
	if ( @Whom == @self )
		return false;
	if ( !Whom.HasAI() )
		return false;
	if ( !Whom.IsNPC() )
		return false;
	if ( Whom.IsKnockedOut() )
		return false;
	if ( Whom.GetAttr("cr_imacop") != 1 )
		return false;
	if ( Whom.GetCurGroup() != "Neutral" )
		return false;
	
	// I think it's totally useless to check for distance here - Kizoky
	//float flDist = (self.GetBaseEntity().GetAbsOrigin() - arr[i].GetBaseEntity().GetAbsOrigin()).Length2DSqr();
	//if (flDist > radius * radius)
		//continue;
	
	if ( !CanSeeSpot(Whom, targ.GetBaseEntity().GetAbsOrigin()+Vector(0,0,17), true) )
		return false;
	
	return true;
}

void AlertCops(CP3SObj@ self, CP3SObj@ target)
{
	float radius = self.GetViewRange();
	
	// wtf?
	if (radius < 0)
	{
		radius = 960.0f;
		return;
	}
	
	if (@target == null)
		return;
	
	array<CP3SObj@> arr = engine.GetArrayOfEntitiesRadius(self, radius);
	for (uint i = 0; i < arr.length(); i++)
	{
		if (!IsValidCopForTargeting(self, arr[i], target))
			continue;
			
		arr[i].SetTarget(target);
		arr[i].SetEnemy(target);
		//arr[i].State("st_judgementfailSRC");
	}
}