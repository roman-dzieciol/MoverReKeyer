// ============================================================================
//  MoverReKeyer:	 
//  UnrealEd plugin, updates keyframes of moved/rotated movers.
// 
//  Copyright 2005 Roman Switch` Dzieciol, neai o2.pl
//  http://wiki.beyondunreal.com/wiki/Switch
// ============================================================================
class MoverReKeyer extends BrushBuilder;


// ----------------------------------------------------------------------------
// Enums
// ----------------------------------------------------------------------------

enum EPluginPhase
{
	P_Store,
	P_ReKey
};


// ----------------------------------------------------------------------------
// Structs
// ----------------------------------------------------------------------------

struct SEditorActor
{
	var string Actor;
	var int MaxId;
};


// ----------------------------------------------------------------------------
// Internal
// ----------------------------------------------------------------------------

var array<SEditorActor> EditorActors;	// 
var Actor TempEditorActor;				// 
var array<MoverReKeyerObject> ReKeyers;	// Rekeyer objects


// ----------------------------------------------------------------------------
// Parameters
// ----------------------------------------------------------------------------

var() EPluginPhase Phase;				// MoverReKeyer phase


// ----------------------------------------------------------------------------
// Entry point
// ----------------------------------------------------------------------------

event bool Build()
{
	local Actor A;
	
	// Show mode
	Log( "-------------------------------------------------------------------", class.name );
	Log( "PHASE:" @ GetEnum(enum'EPluginPhase',Phase), class.name );
	Log( "-------------------------------------------------------------------", class.name );
	
	// Find actor reference
	if( !FindAnyActor(A) )
		return false;	
		
	// Phases
	switch( Phase )
	{
		case P_Store:
			if( !StoreMovers(A) )	return false;
			break;
		
		case P_ReKey:
			if( !ReKeyMovers(A) )	return false;
			break;
	}		
	
	return false;
}


// ----------------------------------------------------------------------------
// Phases
// ----------------------------------------------------------------------------

final function bool StoreMovers( Actor A )
{
	local Mover M;
	local MoverReKeyerObject O;
	
	ReKeyers.remove(0,ReKeyers.Length);
	
	foreach A.AllActors(class'Mover',M)
	{
		if( M.bSelected )
		{
			O = new (M) class'MoverReKeyerObject';
			O.StoreMover(self);
			ReKeyers[ReKeyers.Length] = O;
		}
	}

	if( ReKeyers.Length == 0 )
		return ShowError( ReKeyers.Length @"Movers found." );	

	Phase = P_ReKey;
	return ShowSuccess( ReKeyers.Length @"Movers found."$ Chr(10) $"Click again to re-key movers." );	
}

final function bool ReKeyMovers( Actor A )
{
	local int counter,i;
	
	if( ReKeyers.Length == 0 )
	{
		Phase = P_Store;
		return ShowError( "No movers were stored, try again." );	
	}
			
	for( i=0; i!=ReKeyers.Length; ++i )
	{
		if( !ReKeyers[i].ReKeyMover(self) )
		{
			Phase = P_Store;
			return ShowError( counter @"of"@ ReKeyers.Length @"Movers re-keyed." );
		}
		++counter;
	}
	
	Phase = P_Store;
	ReKeyers.remove(0,ReKeyers.Length);
	return ShowSuccess( counter @"Movers re-keyed." );
}	


// ----------------------------------------------------------------------------
// Internal
// ----------------------------------------------------------------------------

function bool ShowSuccess( coerce string S )
{
	Log( "" $ S, class.name );
	BadParameters( "" $ S );
	return true;
}

function bool ShowError( coerce string S )
{
	Log(  "Error: " $ S, class.name );
	BadParameters( "Error: " $ S );
	return false;
}

function bool FindAnyActor( out Actor A )
{
	local SEditorActor E;
	local int i,j;
	
	for( i=0; i!=EditorActors.Length; ++i )
	{
		E = EditorActors[i];
		for( j=0; j!=E.MaxId; ++j )
		{
			SetPropertyText("TempEditorActor",E.Actor$j);
			if( TempEditorActor != None )
			{
				A = TempEditorActor;
				TempEditorActor = None;
				Log( "Actor Ref:" @ A, class.name );
				return true;
			}
		}
	}	
	return ShowError( "Could not find any actors in the level." );
}


// ----------------------------------------------------------------------------
// DefaultProperties
// ----------------------------------------------------------------------------
DefaultProperties
{
	ToolTip="MoverReKeyer"
	BitmapFilename="MoverReKeyer"
	
	Phase=P_Store
	
	EditorActors(0)=(Actor="MyLevel.LevelInfo",MaxId=8)
	EditorActors(1)=(Actor="MyLevel.Camera",MaxId=64)
	EditorActors(2)=(Actor="MyLevel.Brush",MaxId=128)
}
