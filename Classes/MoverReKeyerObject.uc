// ============================================================================
//  MoverReKeyerObject:	 
//  UnrealEd plugin, updates keyframes of moved/rotated movers.
// 
//  Copyright 2005 Roman Switch` Dzieciol, neai o2.pl
//  http://wiki.beyondunreal.com/wiki/Switch
// ============================================================================
class MoverReKeyerObject extends Object within Mover;

var byte 				StoredKeyLength;	//
var array<vector>		StoredKeyPos;		//
var array<rotator>		StoredKeyRot;		//
var vector 				StoredBasePos;		//
var rotator				StoredBaseRot;		//
var vector    			StoredLocation;		//
var rotator    			StoredRotation;		//
var byte 				StoredKeyNum;		//

var Mover				StoredMover;		// same as outer
var string				StoredString;		// mover name, duplication-proof


//
// Duplicating something in UnrealEd results in object names being swapped.
// New object gets old name, old object gets new name.
//


// ----------------------------------------------------------------------------
// Accessors
// ----------------------------------------------------------------------------

final function int GetKeyPosLength() 			{ return ArrayCount(KeyPos); }
final function int GetKeyRotLength() 			{ return ArrayCount(KeyRot); }
final function vector GetKeyPos( int i ) 		{ return KeyPos[i]; }
final function rotator GetKeyRot( int i ) 		{ return KeyRot[i]; }
final function SetKeyPos( int i, vector v ) 	{ KeyPos[i] = v; }
final function SetKeyRot( int i, rotator r ) 	{ KeyRot[i] = r; }


// ----------------------------------------------------------------------------
// Check
// ----------------------------------------------------------------------------

final function bool IsModified( MoverReKeyerObject M )
{
	local int i;

	if( M.Rotation != StoredRotation
	||	M.Location != StoredLocation
	||	M.BaseRot != StoredBaseRot
	||	M.BasePos != StoredBasePos )
		return true;
	
	for( i=0; i!=StoredKeyLength; ++i )
		if( M.GetKeyPos(i) != StoredKeyPos[i] )
			return true;

	for( i=0; i!=StoredKeyLength; ++i )
		if( M.GetKeyRot(i) != StoredKeyRot[i] )
			return true;

	return false;
}

final function bool IsBroken( MoverReKeyerObject M )
{	
	if( StoredKeyNum != M.KeyNum )
		return true;
	
	return false;
}


// ----------------------------------------------------------------------------
// Store
// ----------------------------------------------------------------------------

final function bool StoreMover( MoverReKeyer B )
{
	local int i;
	
	StoredKeyLength = GetKeyPosLength();
	for( i=0; i!=StoredKeyLength; ++i ) { StoredKeyPos[i] = GetKeyPos(i); }
	for( i=0; i!=StoredKeyLength; ++i ) { StoredKeyRot[i] = GetKeyRot(i); }
	StoredBasePos = Outer.BasePos;
	StoredBaseRot = Outer.BaseRot;
	StoredLocation = Outer.Location;
	StoredRotation = Outer.Rotation;
	StoredKeyNum = Outer.KeyNum;
	StoredMover = Outer;
	StoredString = string(Outer);
	
	Log( "STORED:" @ Outer, B.class.name );
	return true;
}


// ----------------------------------------------------------------------------
// ReKey
// ----------------------------------------------------------------------------

final function bool ReKeyMover( MoverReKeyer B )
{
	local MoverReKeyerObject M;

	if( StoredString == string(Outer) )
	{
		return UpdateMover(B,self);
	}
	else
	{
		// duplicated, get name
		SetPropertyText("StoredMover", StoredString);
		M = new (StoredMover) class'MoverReKeyerObject';
		return UpdateMover(B,M);
	}
}
	
final function bool UpdateMover( MoverReKeyer B, MoverReKeyerObject M )
{	
	local int i;
	local rotator DeltaRot;
	local vector BaseLocation;
	
	if( IsBroken(M) )
	{
		return B.ShowError( "Mover"@ StoredMover @"has differrent keyframe selected."$ Chr(10) $"Reload level and try again." );
	}
	
	if( !IsModified(M) )
	{
		B.ShowSuccess( "No changes found in Mover"@ StoredMover );
	}	
	
	if( StoredKeyNum == 0 )
	{		
		// Get rotation delta
		DeltaRot = StoredMover.Rotation - StoredRotation;
		
		// Update KeyPos
		for( i=0; i!=StoredKeyLength; ++i )
		{
			M.SetKeyPos( i, StoredKeyPos[i] >> DeltaRot );
		}
		
		// Restore KeyRot, just in case
		for( i=0; i!=StoredKeyLength; ++i )
		{
			M.SetKeyRot( i, StoredKeyRot[i] );
		}	
		
		// Location, Rotation, BasePos and BaseRot should be already updated
	}
	else
	{
		// Get rotation delta
		DeltaRot = StoredMover.Rotation - StoredRotation;
		
		// Update KeyPos
		for( i=0; i!=StoredKeyLength; ++i )
		{
			M.SetKeyPos( i, StoredKeyPos[i] >> DeltaRot );
		}
		
		// Restore KeyRot
		for( i=0; i!=StoredKeyLength; ++i )
		{
			M.SetKeyRot( i, StoredKeyRot[i] );
		}	
		
		BaseLocation = StoredMover.Location - ( (StoredKeyPos[StoredKeyNum]) >> DeltaRot );
		
		// BasePos doesnt like to change
		StoredMover.BasePos = BaseLocation;
		StoredMover.BaseRot = DeltaRot;
		
		// Update Location, BasePos should update
		StoredMover.SetLocation( BaseLocation + M.GetKeyPos(StoredKeyNum) );
		
		// Rotation should be already updated
	}	
	
	Log( "REKEYED:" @ StoredMover, B.class.name );
	return true;
}


// ----------------------------------------------------------------------------
// DefaultProperties
// ----------------------------------------------------------------------------
DefaultProperties
{
}