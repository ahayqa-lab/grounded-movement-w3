// Sprint mod (keyboard and controller):
//   no Shift / A            -> walk (at any stick tilt)
//   hold Shift / A          -> jog (vanilla "run")
//   double-tap Shift / A    -> sprint (keep holding the second tap)
// Out of combat only; in combat movement is vanilla. Clicking the left stick
// (game option "Left stick sprint", on by default) still toggles vanilla sprint.

// Max time between the two Shift presses to count as a double tap (seconds).
function SprintModDoubleTapWindow() : float
{
	return 0.35;
}

@addField(CR4Player) var sprintModLastPress : float;
@addField(CR4Player) var sprintModDoubleTap : bool;

// True when the mod controls movement right now.
@addMethod(CR4Player) function SprintModActive() : bool
{
	return !IsInCombat() && !GetIsSprintToggled();
}

@addMethod(CR4Player) function SprintModOnShift( pressed : bool )
{
	var now : float;

	if ( pressed )
	{
		now = theGame.GetEngineTimeAsSeconds();
		sprintModDoubleTap = sprintModLastPress > 0 && now - sprintModLastPress <= SprintModDoubleTapWindow();
		sprintModLastPress = now;
	}
	else
	{
		sprintModDoubleTap = false;
	}
}

// Shift ('Sprint' action) presses and releases feed the double-tap detector.
@wrapMethod(CPlayerInput) function OnCommSprint( action : SInputAction )
{
	var result : bool;

	if ( IsPressed( action ) )
		thePlayer.SprintModOnShift( true );
	else if ( IsReleased( action ) )
		thePlayer.SprintModOnShift( false );

	result = wrappedMethod( action );
	return result;
}

// Default walk: report "walk toggled" unless Shift is held. The locomotion
// controller then walks instead of jogging.
@wrapMethod(CPlayer) function GetIsWalkToggled() : bool
{
	var r4 : CR4Player;

	r4 = (CR4Player)this;
	if ( r4 && r4.SprintModActive() )
		return !theInput.IsActionPressed( 'Sprint' );

	return wrappedMethod();
}

// Sprint only after a double tap; a single held Shift stays a jog.
@wrapMethod(CR4Player) function CanSprint( speed : float ) : bool
{
	var active, leftStick, result : bool;

	active = SprintModActive();
	if ( active && !sprintModDoubleTap )
		return false;

	// With "Left stick sprint" on, vanilla only sprints via the stick click;
	// switch it off for the check so the A double tap can sprint.
	// (REDkit allows only one wrappedMethod call per wrapper.)
	leftStick = GetLeftStickSprint();
	if ( active )
		SetLeftStickSprint( false );
	result = wrappedMethod( speed );
	SetLeftStickSprint( leftStick );
	return result;
}
