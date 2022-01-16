printl("[Bomber Team] Loading...")

IncludeScript("klib")

if (!("KLib" in getroottable())){
	throw "[Bomber Team] Error: Klib is not find"
}

DirectorOptions <-
{
	ActiveChallenge = 1

	cm_CommonLimit = 220
	cm_DominatorLimit = 99
	cm_MaxSpecials = 99
	cm_ProhibitBosses = true
	cm_SpecialRespawnInterval = 0
	cm_AggressiveSpecials = true
	// cm_HeadshotOnly = true Too hard
	
	SpecialInitialSpawnDelayMin = 0
	SpecialInitialSpawnDelayMax = 0
	ShouldAllowSpecialsWithTank = false
	EscapeSpawnTanks = false

	BoomerLimit = 99
	SmokerLimit = 0
	HunterLimit = 0
	ChargerLimit = 0
	SpitterLimit = 0
	JockeyLimit = 0
	TankLimit = 0

	DefaultItems = [
        "fireaxe"
	]

	function GetDefaultItem(i){
		if (i < DefaultItems.len()){
			return DefaultItems[i]
		}

		return 0
	}
}

function AllowTakeDamage(d){
	if (!("Victim" in d) || !("Attacker" in d)) return true

	local a = ent(d.Attacker)
	local v = ent(d.Victim)

	if (!IsValid(a) || !IsValid(v)) return true
	if (v.GetClass() == "infected" && a.IsPlayer() && !a.IsSurvivor()) return false

	local bomber

	if (a.IsPlayer() && !a.IsSurvivor())
		bomber = a
	else if (v.IsPlayer() && !v.IsSurvivor())
		bomber = v

	if (IsValid(bomber)){
		if (a.toent() != v.toent()){
			local e = ent().Create("env_explosion",bomber.GetPos(),QAngle(),{
				targetname = "bomber explosion"
				iRadiusOverride = 150
				fireballsprite = "sprites/zerogxplode.spr"
				ignoredClass = 0
				iMagnitude = 10
				rendermode = 5
				spawnflags = 64
			})

			d.Weapon = e.toent()

			e.Fire("Explode","",0,bomber)

			bomber.TakeDamage(999999,DMG_GENERIC)
			KLib.Util.SpawnZombie(Z_BOOMER)

			return d
		}
		else
			return false
	}

	return true
}

function OnGameEvent_player_spawn(params){
	if (!("userid" in params)) return

	local ply = ent(params.userid)

	if (!ply.IsSurvivor())
		ply.SetNP("m_flLaggedMovementValue",5.0)
}
