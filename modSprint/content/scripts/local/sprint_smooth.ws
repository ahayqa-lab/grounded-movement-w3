// Smooth gait changes (RDR2-style): instead of jumping straight to the new
// speed (walk 0.6, jog 1.0, sprint 1.5), the speed ramps toward it. The
// walk/jog/sprint animation switches when the ramped speed crosses the
// halfway point. Out of combat only; stopping is vanilla.

// How fast the speed may rise / fall, in speed units per second.
// Walk -> jog is 0.4 units, jog -> sprint 0.5 units.
function SprintModAccelRate() : float
{
	return 0.5;		// walk -> jog ~0.8 s, jog -> sprint ~1.0 s
}

function SprintModDecelRate() : float
{
	return 0.6;		// sprint -> walk ~1.5 s
}

@addField(CR4LocomotionPlayerControllerScript) var sprintModSpeed : float;
@addField(CR4LocomotionPlayerControllerScript) var sprintModLastTime : float;

@wrapMethod(CR4LocomotionPlayerControllerScript) function CalculateMoveSpeed() : float
{
	var target, now, dt : float;
	var moveType : int;

	target = wrappedMethod();

	now = theGame.GetEngineTimeAsSeconds();
	dt = ClampF( now - sprintModLastTime, 0.0, 0.1 );
	sprintModLastTime = now;

	// Vanilla when not moving, in combat or swimming.
	if ( target <= 0 || player.IsInCombat() || player.IsSwimming() )
	{
		sprintModSpeed = target;
		return target;
	}

	// Starting from standstill: begin at (at most) walking speed.
	if ( sprintModSpeed <= 0 )
		sprintModSpeed = MinF( target, 0.6 );

	if ( sprintModSpeed < target )
		sprintModSpeed = MinF( sprintModSpeed + SprintModAccelRate() * dt, target );
	else if ( sprintModSpeed > target )
		sprintModSpeed = MaxF( sprintModSpeed - SprintModDecelRate() * dt, target );

	// Animation gait from the ramped speed (halfway points 0.8 and 1.25).
	if ( sprintModSpeed > 1.25 )
		moveType = (int)PMT_Sprint;
	else if ( sprintModSpeed > 0.8 )
		moveType = (int)PMT_Run;
	else
		moveType = (int)PMT_Walk;

	player.SetBehaviorVariable( 'playerMoveType', moveType );
	player.SetBehaviorVariable( 'playerMoveTypeForOverlay', moveType );

	return sprintModSpeed;
}
