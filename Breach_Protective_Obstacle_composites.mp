/* Comments 2022-12-07
	1. risk events appear in two of the three traces, are these events that if they happen
    	they pose a risk to the mission, or are they part of a regular mission?
    2. The model uses iteration but increasing scope does not show any iteration - this 
    	means some part of the model is locking the rest of it down to one iteration */
    
/*
SCHEMA Breach_Protective_Obstacle

ROOT Obstacle: Present_physical_structure
				Receive_suppressive_fire
	
;

ROOT Enemy_Combatants:
						Commence_fire


;

ROOT Squadron:
				{ Base_of_Fire_Element,
                  Breaching_Fire_Team,
                  Team_1,
                  Team_2,
                  Squad_Leader }

;

 Base_of_Fire_Element:	Commence_suppression
							/*Stop_suppression
							[Continue_suppression]
*/
/*
							(* ( Stop_suppression | Continue_suppression_elsewhere ) *)
;


 Breaching_Fire_Team:	Move_near_breach_point
							
                             (Regroup_with_squad | Initialize_breach
                                ( + Employ_smoke_grenades + ))
							
;

COORDINATE $a: Commence_suppression, $b: Move_near_breach_point
	DO ADD $a PRECEDES $b; OD;



Squad_Leader:	 ( Confirm_breach_point  
					[Signal_suppressing_element_away_from_breach_point]
					( +Employ_smoke_grenades+)
					(*Reposition_to_command * )
					[Verify_foothold_established
					Call_next_fire_team]
    
					| Deny_breach_point)

					Report_to_platoon_leader
    
    ;


COORDINATE $a: Move_near_breach_point, $b: ( Confirm_breach_point | Deny_breach_point )
	DO ADD $a PRECEDES $b; OD;


COORDINATE $a: Confirm_breach_point, $b: Initialize_breach
	DO ADD $a PRECEDES $b; OD;
COORDINATE $a: Deny_breach_point, $b: Regroup_with_squad
	DO ADD $a PRECEDES $b; OD;

COORDINATE $a: Initialize_breach, $b: Signal_suppressing_element_away_from_breach_point
	DO ADD $a PRECEDES $b; OD;

COORDINATE $a: Signal_suppressing_element_away_from_breach_point, $b: ( Stop_suppression | Continue_suppression_elsewhere)
	DO ADD $a PRECEDES $b; OD;

IF #Regroup_with_squad > 0 THEN 
	COORDINATE $a: Regroup_with_squad, $b: Report_to_platoon_leader
		DO ADD $a PRECEDES $b; OD;

FI;
/*
Squad_Leader, Breaching_Fire_Team SHARE ALL Employ_smoke_grenades;
*//*
 Team_1:	
				(
    			Provide_local_security
				Move_to_far_side_of_obstacle
				Mark_cleared_lanes
				Block_enemy_movement )
				
;

/*COORDINATE $a: Signal_suppressing_element_away_from_breach_point, $b: Provide_local_security
	DO ADD $a PRECEDES $b; OD;*/
/*
 Team_2:	
    			( * Move_to_breach_point
				Probe_for_mines
				Mark_path
				Create_breach
				Move_to_far_side_of_obstacle
				Mark_cleared_lanes
				Block_enemy_movement * )

;



/*Team_1, Team_2 SHARE ALL Move_to_far_side_of_obstacle, Mark_cleared_lanes, Block_enemy_movement;
*/
/*
COORDINATE $a: Employ_smoke_grenades, $b: Move_to_breach_point
	DO ADD $a PRECEDES $b; OD;

COORDINATE $a: Move_to_breach_point, $b: Reposition_to_command
	DO ADD $a PRECEDES $b; OD;
 
COORDINATE $a: Reposition_to_command, $b: Probe_for_mines
	DO ADD $a PRECEDES $b; OD;

COORDINATE $a: Create_breach, $b: Move_to_far_side_of_obstacle
	DO ADD $a PRECEDES $b; OD;

COORDINATE $a: Block_enemy_movement, $b: Verify_foothold_established
	DO ADD $a PRECEDES $b; OD;

COORDINATE $a: Verify_foothold_established, $b: Call_next_fire_team
	DO ADD $a PRECEDES $b; OD;

/* Comments 2022-12-07
	1. risk events appear in two of the three traces, are these events that if they happen
    	they pose a risk to the mission, or are they part of a regular mission?
    2. The model uses iteration but increasing scope does not show any iteration - this 
    	means some part of the model is locking the rest of it down to one iteration
        

         
Page Numbers in the Marine Rifle Squad manual: pg. 70-71 (pdf numbers) or 3-24 to 3-25 


Assumption made on the order of the confirming breach point before the team moves
 near breach point.



        */

/*┬────────────────────────────────────────────────────────┐
│*│ ┌─[ Title and Authors ]──────────────────────────────┐ │
│*│ │ Model of a Marines Combat Scenario: Breaching a    │ │
│*│ │ Protective Obstacle                                │ │
│*│ │  Created by Alex Nguyen on the nth  of             │ │
│*│ │     March, 2023.                                   │ │
│*│ └────────────────────────────────────────────────────┘ │
│*│                                                        │
│*│ ┌─[ Purpose ]────────────────────────────────────────┐ │
│*│ │ To demonstrate detailed risk analysis of a Marines │ │
│*│ │ combat scenario by assigning impact and likelihood │ │
│*│ │ to calculate individual and total risk scores.     │ │
│*│ └────────────────────────────────────────────────────┘ │
│*│                                                        │
│*│ ┌─[ Description ]────────────────────────────────────┐ │
│*│ │ This model demonstrates performing detailed risk   │ │
│*│ │ analysis on Marines procedures of breaching        │ │
│*│ │ protective obstacles based on the Marines Rifle    │ │
│*│ │ Squad manual.                                      │ │
│*│ │                                                    │ │
│*│ │ The hierarchy of the squadron and members was      │ │
│*│ │ established using composite events.                │ │
│*│ │ Attributes were used to assign the likelihood and  │ │
│*│ │ impact values to certain influential events.       │ │
│*│ │ Trace risk scores are then calculated by           │ │
│*│ │ multiplying the two values together.               │ │
│*│ │                                                    │ │
│*│ │                                                    │ │
│*│ │ Each trace that is above a certain threshold value | |
|*| | is marked, and a global risk report is issued. This| |
|*| | report contains the total risk across the total    | |
|*| | number of traces, highest risk, average risk, and a| |
|*| | direction to sort traces by those marked first.    | |
|*| | Decision makers can reference models such as this  | |
|*| | when in need of assessing and comparing risk across| |
|*| | multiple scenarios from multiple threats,          | |
|*| | especially when it is necessary to best allocate   | |
|*| | limited resources for training units.              | │
│*│ └────────────────────────────────────────────────────┘ │
│*│                                                        │
│*│ ┌─[ References ]─────────────────────────────────────┐ │
│*│ │ U.S. Marine Corps Marine Rifle Squad MCRP 3-10.4   │ │
│*│ │ pages 3-24 to 3-25.                                │ │
│*│ └────────────────────────────────────────────────────┘ │
│*│                                                        │
│*│ ┌─[ Search Terms ]───────────────────────────────────┐ │
│*│ │ behavior, Marines combat scenario; analysis, risk; │ │
│*│ │ likelihood, impact, event attribute, table; trace  | |
|*| | annotation; risk score; SAY statement;             │ │
│*│ │ MARK command; report, global                       │ │
│*│ └────────────────────────────────────────────────────┘ │
│*│                                                        │
│*│ ┌─[ Instructions ]───────────────────────────────────┐ │
│*│ │ Run for Scopes 1 and up. You may also make changes │ │
│*│ │ to this model and run it with your changes. Save   │ │
│*│ │ your model using the EXPORT button.                │ │
│*│ ├─[ Run Statistics ]─────────────────────────────────┤ │
│*│ │ Scope 1: x traces in less than x sec.              │ │
│*│ │ Scope 2: x traces in approx. x sec.              │ │
│*│ │ Scope 3: x traces in approx. x min.             │ │
│*│ └────────────────────────────────────────────────────┘ │
└*┴───────────────────────────────────────────────────────*/




SCHEMA Breach_Protective_Obstacle

ROOT Obstacle: Present_physical_structure
			   Structure_suppressed
			   Structure_obscured
			   (* Physical_structure_breached *)
			   
				
	
;

ROOT Enemy_Combatants: Commence_fire
					  Recieve_suppressive_fire
					  (Retreat_from_obstacle | Push_back)
					  
;


ROOT Marine_Platoon:
				{ Base_of_Fire_Element,
                  Breaching_Fire_Team,
                  Other_Platoon_Members
                    /*
                  Team_1,
                  Team_2,
                  Squad_Leader*/ }

;


 Base_of_Fire_Element:	Commence_suppression
						Continue_suppression_of_enemy_positions
		
;




 Breaching_Fire_Team:	 
						 {Squad_Leader,
     					 Team_1,
     					 Team_2,}
						 
						 


;


Other_Platoon_Members:
						Seize_foothold_with_remainder_of_platoon


;

/*( Move_near_breach_point
     					  Initialize_breach |
     					  Regroup_with_squad )

							
                            /*(+ (Regroup_with_squad | Initialize_breach) +) ) */
                                /* (* Employ_smoke_grenades *)
							
;
/*
COORDINATE $a: Commence_suppression, $b: Move_near_breach_point
	DO ADD $a PRECEDES $b; OD;
*/


 Squad_Leader:	(   Move_to_last_covered_position_near_breach_point
     				Confirm_breach_point 
					[Signal_suppression_away_from_breach_point]

					Employ_smoke_grenades
					Occupy_position_from_which_best_to_control_fire_teams
     
     				Remain_at_entry_point_and_call_forward_next_fire_team
     				
     				
     
					Verify_foothold_established
     )
     				/*| Deny_breach_point)*/
					Report_to_platoon_leader
;


 Team_1:		/*Move_to_last_covered_position_near_breach_point*/

				{Fire_Team_Leader,
     			 Automatic_Rifleman}
				/*( *
    			Provide_local_security
               		
				Move_to_far_side_of_obstacle
				Mark_cleared_lanes
				Block_enemy_movement * )*/
				
;


Fire_Team_Leader:
					Move_to_last_covered_position_near_breach_point
					Occupy_position_short_of_breach_point
					Provide_local_security_for_Team_2
					Employ_smoke_grenades

					Move_to_far_side_of_the_obstacle_checking_for_mines_and_marking_cleared_lanes
					Take_up_covered_and_concealed_positions_to_block_any_enemy_movement_toward_breach_point
					Engage_any_identified_or_likely_enemy_positions

					
					Establish_foothold



;


COORDINATE 	$a: Fire_Team_Leader FROM Marine_Platoon,
			$b: Squad_Leader  FROM Marine_Platoon 
	DO	COORDINATE 	$c: Employ_smoke_grenades FROM $a,
               		$d: Employ_smoke_grenades FROM $b 
    	DO SHARE $c $d; OD;
 	OD;




COORDINATE $a: Employ_smoke_grenades, $b: Structure_obscured
	DO ADD $a PRECEDES $b; OD;








Automatic_Rifleman:
					Move_to_last_covered_position_near_breach_point
					Occupy_position_short_of_breach_point
					Provide_local_security_for_Team_2



					Move_to_far_side_of_the_obstacle_checking_for_mines_and_marking_cleared_lanes
					Take_up_covered_and_concealed_positions_to_block_any_enemy_movement_toward_breach_point
					Engage_any_identified_or_likely_enemy_positions
					
					Establish_foothold


;

COORDINATE 	$a: Fire_Team_Leader FROM Marine_Platoon,
			$b: Automatic_Rifleman  FROM Marine_Platoon 
	DO	COORDINATE 	$c: Occupy_position_short_of_breach_point FROM $a,
               		$d: Occupy_position_short_of_breach_point FROM $b 
    	DO SHARE $c $d; OD;
 	OD;

COORDINATE 	$a: Fire_Team_Leader FROM Marine_Platoon,
			$b: Automatic_Rifleman  FROM Marine_Platoon 
	DO	COORDINATE 	$c: Provide_local_security_for_Team_2 FROM $a,
               		$d: Provide_local_security_for_Team_2 FROM $b 
    	DO SHARE $c $d; OD;
 	OD;

 Team_2:		
				/*Move_to_last_covered_position_near_breach_point*/
				{Grenadier,
     			 Rifleman,
     			 Attachments}

    			/*( * Move_to_breach_point
				Probe_for_mines
				Mark_path
				Create_breach
				Move_to_far_side_of_obstacle
				Mark_cleared_lanes
				Block_enemy_movement * )*/

;


Grenadier:
			 Move_to_last_covered_position_near_breach_point
			(Rush_to_breach_point | Crawl_to_breach_point)
			 Position_right_and_left_of_breach_point_near_obstacle
			 Probe_for_mines_and_mark_path
			(Create_breach_through_explosive_means | Create_breach_through_mechanical_means)

			Move_to_far_side_of_the_obstacle_checking_for_mines_and_marking_cleared_lanes
			Take_up_covered_and_concealed_positions_to_block_any_enemy_movement_toward_breach_point
			Engage_any_identified_or_likely_enemy_positions
			 
					
					Establish_foothold



;

Rifleman:
			Move_to_last_covered_position_near_breach_point
			(Rush_to_breach_point | Crawl_to_breach_point)
			 Position_right_and_left_of_breach_point_near_obstacle
			 Probe_for_mines_and_mark_path
			(Create_breach_through_explosive_means | Create_breach_through_mechanical_means)


			Move_to_far_side_of_the_obstacle_checking_for_mines_and_marking_cleared_lanes
			Take_up_covered_and_concealed_positions_to_block_any_enemy_movement_toward_breach_point
			Engage_any_identified_or_likely_enemy_positions
					
					Establish_foothold

;



Attachments:
			Move_to_last_covered_position_near_breach_point
			(Rush_to_breach_point | Crawl_to_breach_point)
			 Position_right_and_left_of_breach_point_near_obstacle
			 Probe_for_mines_and_mark_path
			(Create_breach_through_explosive_means | Create_breach_through_mechanical_means)



			Move_to_far_side_of_the_obstacle_checking_for_mines_and_marking_cleared_lanes
			Take_up_covered_and_concealed_positions_to_block_any_enemy_movement_toward_breach_point
			Engage_any_identified_or_likely_enemy_positions
					
					Establish_foothold

;



COORDINATE 	$a: Grenadier FROM Marine_Platoon,
			$b: Rifleman  FROM Marine_Platoon 
	DO	COORDINATE 	$c: (Rush_to_breach_point | Crawl_to_breach_point) FROM $a,
               		$d: (Rush_to_breach_point | Crawl_to_breach_point) FROM $b 
    	DO SHARE $c $d; OD;
 	OD;

COORDINATE 	$a: Attachments FROM Marine_Platoon,
			$b: Rifleman  FROM Marine_Platoon 
	DO	COORDINATE 	$c: (Rush_to_breach_point | Crawl_to_breach_point) FROM $a,
               		$d: (Rush_to_breach_point | Crawl_to_breach_point) FROM $b 
    	DO SHARE $c $d; OD;
 	OD;





COORDINATE 	$a: Grenadier FROM Marine_Platoon,
			$b: Rifleman  FROM Marine_Platoon 
	DO	COORDINATE 	$c: Position_right_and_left_of_breach_point_near_obstacle FROM $a,
               		$d: Position_right_and_left_of_breach_point_near_obstacle FROM $b 
    	DO SHARE $c $d; OD;
 	OD;

COORDINATE 	$a: Attachments FROM Marine_Platoon,
			$b: Rifleman  FROM Marine_Platoon 
	DO	COORDINATE 	$c: Position_right_and_left_of_breach_point_near_obstacle FROM $a,
               		$d: Position_right_and_left_of_breach_point_near_obstacle FROM $b 
    	DO SHARE $c $d; OD;
 	OD;

COORDINATE 	$a: Grenadier FROM Marine_Platoon,
			$b: Rifleman  FROM Marine_Platoon 
	DO	COORDINATE 	$c: Probe_for_mines_and_mark_path FROM $a,
               		$d: Probe_for_mines_and_mark_path FROM $b 
    	DO SHARE $c $d; OD;
 	OD;

COORDINATE 	$a: Attachments FROM Marine_Platoon,
			$b: Rifleman  FROM Marine_Platoon 
	DO	COORDINATE 	$c: Probe_for_mines_and_mark_path FROM $a,
               		$d: Probe_for_mines_and_mark_path FROM $b 
    	DO SHARE $c $d; OD;
 	OD;

COORDINATE 	$a: Grenadier FROM Marine_Platoon,
			$b: Rifleman  FROM Marine_Platoon 
	DO	COORDINATE 	$c: (Create_breach_through_explosive_means | Create_breach_through_mechanical_means)
 FROM $a,
               		$d: (Create_breach_through_explosive_means | Create_breach_through_mechanical_means)
 FROM $b 
    	DO SHARE $c $d; OD;
 	OD;

COORDINATE 	$a: Attachments FROM Marine_Platoon,
			$b: Rifleman  FROM Marine_Platoon 
	DO	COORDINATE 	$c: (Create_breach_through_explosive_means | Create_breach_through_mechanical_means)
 FROM $a,
               		$d: (Create_breach_through_explosive_means | Create_breach_through_mechanical_means)
 FROM $b 
    	DO SHARE $c $d; OD;
 	OD;





/* SHARE COORDINATES AFTER THE BREACH */

COORDINATE 	$a: Fire_Team_Leader FROM Marine_Platoon,
			$b: Rifleman FROM Marine_Platoon
	DO	COORDINATE 	$c: Move_to_far_side_of_the_obstacle_checking_for_mines_and_marking_cleared_lanes FROM $a,
               		$d: Move_to_far_side_of_the_obstacle_checking_for_mines_and_marking_cleared_lanes FROM $b
    	DO SHARE $c $d; OD;
 	OD;


COORDINATE 	$a: Automatic_Rifleman FROM Marine_Platoon,
			$b: Rifleman FROM Marine_Platoon
	DO	COORDINATE 	$c: Move_to_far_side_of_the_obstacle_checking_for_mines_and_marking_cleared_lanes FROM $a,
               		$d: Move_to_far_side_of_the_obstacle_checking_for_mines_and_marking_cleared_lanes FROM $b
    	DO SHARE $c $d; OD;
 	OD;

COORDINATE 	$a: Grenadier FROM Marine_Platoon,
			$b: Rifleman FROM Marine_Platoon
	DO	COORDINATE 	$c: Move_to_far_side_of_the_obstacle_checking_for_mines_and_marking_cleared_lanes FROM $a,
               		$d: Move_to_far_side_of_the_obstacle_checking_for_mines_and_marking_cleared_lanes FROM $b
    	DO SHARE $c $d; OD;
 	OD;


COORDINATE 	$a: Attachments FROM Marine_Platoon,
			$b: Rifleman FROM Marine_Platoon
	DO	COORDINATE 	$c: Move_to_far_side_of_the_obstacle_checking_for_mines_and_marking_cleared_lanes FROM $a,
               		$d: Move_to_far_side_of_the_obstacle_checking_for_mines_and_marking_cleared_lanes FROM $b
    	DO SHARE $c $d; OD;
 	OD;





COORDINATE 	$a: Fire_Team_Leader FROM Marine_Platoon,
			$b: Rifleman FROM Marine_Platoon
	DO	COORDINATE 	$c: Take_up_covered_and_concealed_positions_to_block_any_enemy_movement_toward_breach_point FROM $a,
               		$d: Take_up_covered_and_concealed_positions_to_block_any_enemy_movement_toward_breach_point FROM $b
    	DO SHARE $c $d; OD;
 	OD;


COORDINATE 	$a: Automatic_Rifleman FROM Marine_Platoon,
			$b: Rifleman FROM Marine_Platoon
	DO	COORDINATE 	$c: Take_up_covered_and_concealed_positions_to_block_any_enemy_movement_toward_breach_point FROM $a,
               		$d: Take_up_covered_and_concealed_positions_to_block_any_enemy_movement_toward_breach_point FROM $b
    	DO SHARE $c $d; OD;
 	OD;

COORDINATE 	$a: Grenadier FROM Marine_Platoon,
			$b: Rifleman FROM Marine_Platoon
	DO	COORDINATE 	$c: Take_up_covered_and_concealed_positions_to_block_any_enemy_movement_toward_breach_point FROM $a,
               		$d: Take_up_covered_and_concealed_positions_to_block_any_enemy_movement_toward_breach_point FROM $b
    	DO SHARE $c $d; OD;
 	OD;


COORDINATE 	$a: Attachments FROM Marine_Platoon,
			$b: Rifleman FROM Marine_Platoon
	DO	COORDINATE 	$c: Take_up_covered_and_concealed_positions_to_block_any_enemy_movement_toward_breach_point FROM $a,
               		$d: Take_up_covered_and_concealed_positions_to_block_any_enemy_movement_toward_breach_point FROM $b
    	DO SHARE $c $d; OD;
 	OD;









COORDINATE 	$a: Fire_Team_Leader FROM Marine_Platoon,
			$b: Rifleman FROM Marine_Platoon
	DO	COORDINATE 	$c: Engage_any_identified_or_likely_enemy_positions FROM $a,
               		$d: Engage_any_identified_or_likely_enemy_positions FROM $b
    	DO SHARE $c $d; OD;
 	OD;


COORDINATE 	$a: Automatic_Rifleman FROM Marine_Platoon,
			$b: Rifleman FROM Marine_Platoon
	DO	COORDINATE 	$c: Engage_any_identified_or_likely_enemy_positions FROM $a,
               		$d: Engage_any_identified_or_likely_enemy_positions FROM $b
    	DO SHARE $c $d; OD;
 	OD;

COORDINATE 	$a: Grenadier FROM Marine_Platoon,
			$b: Rifleman FROM Marine_Platoon
	DO	COORDINATE 	$c: Engage_any_identified_or_likely_enemy_positions FROM $a,
               		$d: Engage_any_identified_or_likely_enemy_positions FROM $b
    	DO SHARE $c $d; OD;
 	OD;


COORDINATE 	$a: Attachments FROM Marine_Platoon,
			$b: Rifleman FROM Marine_Platoon
	DO	COORDINATE 	$c: Engage_any_identified_or_likely_enemy_positions FROM $a,
               		$d: Engage_any_identified_or_likely_enemy_positions FROM $b
    	DO SHARE $c $d; OD;
 	OD;







COORDINATE 	$a: Fire_Team_Leader FROM Marine_Platoon,
			$b: Rifleman FROM Marine_Platoon
	DO	COORDINATE 	$c: Establish_foothold FROM $a,
               		$d: Establish_foothold FROM $b
    	DO SHARE $c $d; OD;
 	OD;


COORDINATE 	$a: Automatic_Rifleman FROM Marine_Platoon,
			$b: Rifleman FROM Marine_Platoon
	DO	COORDINATE 	$c: Establish_foothold FROM $a,
               		$d: Establish_foothold FROM $b
    	DO SHARE $c $d; OD;
 	OD;

COORDINATE 	$a: Grenadier FROM Marine_Platoon,
			$b: Rifleman FROM Marine_Platoon
	DO	COORDINATE 	$c: Establish_foothold FROM $a,
               		$d: Establish_foothold FROM $b
    	DO SHARE $c $d; OD;
 	OD;


COORDINATE 	$a: Attachments FROM Marine_Platoon,
			$b: Rifleman FROM Marine_Platoon
	DO	COORDINATE 	$c: Establish_foothold FROM $a,
               		$d: Establish_foothold FROM $b
    	DO SHARE $c $d; OD;
 	OD;










COORDINATE 	$a: Fire_Team_Leader FROM Marine_Platoon,
			$b: Squad_Leader FROM Marine_Platoon
	DO	COORDINATE 	$c: Move_to_last_covered_position_near_breach_point FROM $a,
               		$d: Move_to_last_covered_position_near_breach_point FROM $b
    	DO SHARE $c $d; OD;
 	OD;


COORDINATE 	$a: Automatic_Rifleman FROM Marine_Platoon,
			$b: Squad_Leader FROM Marine_Platoon
	DO	COORDINATE 	$c: Move_to_last_covered_position_near_breach_point FROM $a,
               		$d: Move_to_last_covered_position_near_breach_point FROM $b
    	DO SHARE $c $d; OD;
 	OD;

COORDINATE 	$a: Grenadier FROM Marine_Platoon,
			$b: Squad_Leader FROM Marine_Platoon
	DO	COORDINATE 	$c: Move_to_last_covered_position_near_breach_point FROM $a,
               		$d: Move_to_last_covered_position_near_breach_point FROM $b
    	DO SHARE $c $d; OD;
 	OD;

COORDINATE 	$a: Rifleman FROM Marine_Platoon,
			$b: Squad_Leader FROM Marine_Platoon
	DO	COORDINATE 	$c: Move_to_last_covered_position_near_breach_point FROM $a,
               		$d: Move_to_last_covered_position_near_breach_point FROM $b
    	DO SHARE $c $d; OD;
 	OD;

COORDINATE 	$a: Attachments FROM Marine_Platoon,
			$b: Squad_Leader FROM Marine_Platoon
	DO	COORDINATE 	$c: Move_to_last_covered_position_near_breach_point FROM $a,
               		$d: Move_to_last_covered_position_near_breach_point FROM $b
    	DO SHARE $c $d; OD;
 	OD;







COORDINATE $a: Establish_foothold, $b: Report_to_platoon_leader
	DO ADD $a PRECEDES $b; OD;


COORDINATE $a: Report_to_platoon_leader, $b: Seize_foothold_with_remainder_of_platoon
	DO ADD $a PRECEDES $b; OD;













/*
COORDINATE 	$a: Team_2 FROM Marine_Platoon,
			$b: Squad_Leader FROM Marine_Platoon
	DO	COORDINATE 	$c: Move_to_last_covered_position_near_breach_point FROM $a,
               		$d: Move_to_last_covered_position_near_breach_point FROM $b
    	DO SHARE $c $d; OD;
 	OD;


COORDINATE 	$a: Team_1 FROM Marine_Platoon,
			$b: Squad_Leader  FROM Marine_Platoon 
	DO	COORDINATE 	$c: Move_to_last_covered_position_near_breach_point FROM $a,
               		$d: Move_to_last_covered_position_near_breach_point FROM $b 
    	DO SHARE $c $d; OD;
 	OD;
*/




/*
IF #Confirm_breach_point > 0 THEN 
	COORDINATE $a: Move_near_breach_point, $b: Initialize_breach
		DO ADD $a PRECEDES $b; OD;

FI;

IF #Deny_breach_point > 0 THEN 
	COORDINATE $a: Move_near_breach_point, $b: Regroup_with_squad
		DO ADD $a PRECEDES $b; OD;

FI;
*/
/*
IF #Regroup_with_squad > 0 THEN 
	COORDINATE $a: Regroup_with_squad, $b: Report_to_platoon_leader
		DO ADD $a PRECEDES $b; OD;

FI;














