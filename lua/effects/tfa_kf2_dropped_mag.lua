local cv_maglife = GetConVar("cl_tfa_kf2_maglife") or CreateClientConVar("cl_tfa_kf2_maglife", "15",true, true, "Magazine Lifetime")

EFFECT.LifeTime = 15
EFFECT.MagModel = "models/error.mdl"

function EFFECT:Init(data)
	self.LifeTime = cv_maglife:GetFloat()

	self.WeaponEnt = data:GetEntity()

	local pos, ang = data:GetOrigin(), data:GetAngles()

    local handValue = data:GetScale()

    local boneName = handValue == 0 and "ValveBiped.Bip01_R_Hand" or "ValveBiped.Bip01_L_Hand"

    if IsValid(self.WeaponEnt) then
        if self.WeaponEnt.IsTFAWeapon then
            self.MagModel = self.WeaponEnt:GetStat("MagModel", self.MagModel)
            -- self.MagSound = self.WeaponEnt:GetStat("ProjectileBG", self.ProjectileBG)
    
            if self.WeaponEnt:IsFirstPerson() and self.WeaponEnt:VMIV() then
                local vm = self.WeaponEnt.OwnerViewModel
                ang = vm:GetAngles()
                pos = vm:GetPos() - ang:Up() * 15
    
                -- Retrieve the handValue (0 for left, 1 for right)
                local handValue = data:GetScale()
    
                -- Apply an offset based on the hand value
                local handOffset = handValue == 0 and 10 or -10  -- Adjust this value as needed
                pos = pos + ang:Right() * handOffset
    
                self.IsFirstPerson = true
            end
        end

        if not self.IsFirstPerson and IsValid(self.WeaponEnt:GetOwner()) then
            local owent = self.WeaponEnt:GetOwner()
            local boneid = owent:LookupBone(boneName)
    
            if boneid then
                local bonepos = owent:GetBonePosition(boneid)
    
	    			if bonepos == owent:GetPos() then -- https://wiki.facepunch.com/gmod/Entity:GetBonePosition
	    				bonepos = owent:GetBoneMatrix(boneid):GetTranslation()
	    			end
        
	    		end
	    	end
	end

	self:SetModel(self.MagModel)

	if IsValid(self.WeaponEnt) then
		self:SetMaterial(self.WeaponEnt:GetMaterial())

		for i = 1, #self.WeaponEnt:GetMaterials() do
			self:SetSubMaterial(i - 1, self.WeaponEnt:GetSubMaterial(i - 1))
		end
	end

    local randomRotation = Angle(math.random(-360, 360), math.random(-360, 360), math.random(-360, 360))
    ang:RotateAroundAxis(ang:Forward(), randomRotation.p)
    ang:RotateAroundAxis(ang:Right(), randomRotation.y)
    ang:RotateAroundAxis(ang:Up(), randomRotation.r)

	self:SetPos(pos)
	self:SetAngles(ang)

	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self:SetCollisionBounds(self:OBBMins(), self:OBBMaxs())
	self:PhysicsInitBox(self:OBBMins(), self:OBBMaxs())
	-- self:PhysicsInit(SOLID_VPHYSICS)

	self:SetMoveType(MOVETYPE_VPHYSICS)

	local owent = self.WeaponEnt:GetOwner()
	local velocity = Vector(0,0,0)

	if IsValid(owent) then
		velocity = owent:GetVelocity()
	end

	local physObj = self:GetPhysicsObject()

	if physObj:IsValid() then
		physObj:SetDamping(0.1, 1)
		physObj:SetMass(5)
		physObj:SetMaterial("weapon")
		physObj:SetVelocity(velocity)
		physObj:Wake()
	end
	
	self.CreationTime = CurTime()
	
	self.HasCollided = 0
end

--function EFFECT:PhysicsCollide(data, phys)
--	if self.HasCollided == 0 then
 --       sound.Play(self.MagSound, self.Entity:GetPos(), 100, 100, 1)
--	    self.HasCollided = 1
--	end
--end

function EFFECT:Think()
	if not self.CreationTime or (CurTime() >= (self.CreationTime + self.LifeTime)) then
		return false
	end

	return true
end
