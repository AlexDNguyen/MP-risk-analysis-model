
/*Trace 78 ran at scope 2, No smoke grenades thrown but structure is obscured */
/*┬────────────────────────────────────────────────────────┐
│*│ ┌─[ Title and Authors ]──────────────────────────────┐ │
│*│ │ Model of a Marines Combat Scenario: Breaching a    │ │
│*│ │ Protective Obstacle                                │ │
│*│ │  Created by Alex Nguyen on the nth  of             │ │
│*│ │     February, 2023.                                   │ │
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




SCHEMA Breaching_Protective_Obstacle

ROOT Obstacle: Present_physical_structure
			  /* Structure_suppressed*/
			  ( * Structure_obscured * )
			( * Physical_structure_partially_breached *)
			   Physical_structure_fully_breached
			   
				
	
;

ROOT Enemy_Combatants: Commence_fire
			
					  Retreat_from_obstacle /*| Push_back)
*/					  
;



ROOT Base_of_Fire_Element:	Commence_suppression
						(Continue_suppression_of_enemy_positions_elsewhere | Stop_suppression)
		
;





ROOT Command: 
					 Receive_report_from_squad_leaders
					(* Deploy_successor_fire_teams *)

;


ROOT Squad_Leader:	
					Move_to_last_covered_position_near_breach_point
     				Confirm_breach_point 
					 Signal_suppression_away_from_breach_point
					( * Toss_smoke_grenade * )
                    
                    
					Occupy_position_from_which_best_to_control_fire_teams
     
     				Remain_at_entry_point_and_call_forward_next_fire_team
     				
     				
     /*
     
     				| Deny_breach_point
					  Regroup_with_squad)
*/

					Report_to_platoon_leader

					Secure_objective
;



COORDINATE $a: Signal_suppression_away_from_breach_point, $b: (Continue_suppression_of_enemy_positions_elsewhere 
| Stop_suppression)
	DO ADD $a PRECEDES $b; OD;



/*

COORDINATE $a: Retreat_from_obstacle, $b: Confirm_breach_point
	DO ADD $a PRECEDES $b; OD;

COORDINATE $a: Push_back, $b: Deny_breach_point
	DO ADD $a PRECEDES $b; OD;
*/

ROOT Team_1:		/*Move_to_last_covered_position_near_breach_point*/

				 Move_to_last_covered_position_near_breach_point
				Occupy_position_short_of_breach_point
				Provide_local_security_for_Team_2
				( * Toss_smoke_grenade * )
			
				Move_to_far_side_of_the_obstacle_checking_for_mines_and_marking_cleared_lanes

				Take_up_covered_and_concealed_positions_to_block_any_enemy_movement_toward_breach
				Engage_any_identified_or_likely_enemy_positions

					
				Establish_foothold
				Secure_objective 
               /* Regroup_with_squad ) 
*/
				
;






COORDINATE 	$a: Team_1,
			$b: Squad_Leader 
	DO	COORDINATE 	$c: Toss_smoke_grenade FROM $a,
               		$d: Toss_smoke_grenade FROM $b 
    	DO SHARE $c $d; OD;
 	OD;


ENSURE #Toss_smoke_grenade == 0 <-> #Structure_obscured == 0;


/*
COORDINATE $a: Toss_smoke_grenade, $b: Structure_obscured
DO ADD
		$a PRECEDES $b;
OD;
*/
/* We want to coordinate toss smoke grenade and structure observed
   We want structure obscured to only occur once in each trace 
   If toss smoke grenade is not present in a trace, then we don't to have
   structure obscured to occur 
   If toss smoke grenade happens multiple times, then we only want to 
   coordinate the last occurrence of toss smoke grenade with structure obscured */
COORDINATE $a: Toss_smoke_grenade
DO 
IF #Toss_smoke_grenade AFTER $a == 0 THEN
    COORDINATE  $y: Structure_obscured
        DO ADD $a PRECEDES $y; OD;
FI;

OD;


COORDINATE $a: Deploy_successor_fire_teams
DO 
IF #Deploy_successor_fire_teams == 1 THEN
    COORDINATE  $y: Secure_objective
        DO ADD $a PRECEDES $y; OD;
FI;

OD;


/* ENSURE #Structure_obscured == 2; */
/* ENSURE #Toss_smoke_grenade == 2; */




ROOT Team_2:		

			  Move_to_last_covered_position_near_breach_point
			(Rush_to_breach_point | Crawl_to_breach_point)
			 Position_right_and_left_of_breach_point_near_obstacle
			 Probe_for_mines_and_mark_path
			((* Initiate_breach_through_explosive_means *) | (* Initiate_breach_through_mechanical_means *))
			 /*Receive_local_security*/


			Move_to_far_side_of_the_obstacle_checking_for_mines_and_marking_cleared_lanes
			Take_up_covered_and_concealed_positions_to_block_any_enemy_movement_toward_breach
			Engage_any_identified_or_likely_enemy_positions
            (Continue_holding_positions | Teammate_injured
										  Aid_injured_member)
			
/*
			[ Teammate_injured ]
			( Continue_holding_positions | Aid_injured_member )
					*/
			
			Establish_foothold
			Secure_objective  
		/*	Regroup_with_squad ) 
*/
;

ROOT Other_Platoon_Members:
							Seize_foothold_with_remainder_of_platoon
							Secure_objective
							/*| Regroup_with_squad)

*/
;


/*Deny Breach Events*/
/*
COORDINATE $a: Deny_breach_point, $b: Regroup_with_squad
	DO ADD $a PRECEDES $b; OD;
*/


COORDINATE $a: Structure_obscured, $b: (Rush_to_breach_point | Crawl_to_breach_point)
	DO ADD $a PRECEDES $b; OD;


COORDINATE $a: (Rush_to_breach_point | Crawl_to_breach_point), $b: Occupy_position_from_which_best_to_control_fire_teams
	DO ADD $a PRECEDES $b; OD;



COORDINATE $a: Occupy_position_from_which_best_to_control_fire_teams, $b: Position_right_and_left_of_breach_point_near_obstacle
	DO ADD $a PRECEDES $b; OD;




/* SHARE COORDINATES AFTER THE BREACH */

COORDINATE 	$a: Team_1,
			$b: Team_2
	DO	COORDINATE 	$c: Move_to_far_side_of_the_obstacle_checking_for_mines_and_marking_cleared_lanes FROM $a,
               		$d: Move_to_far_side_of_the_obstacle_checking_for_mines_and_marking_cleared_lanes FROM $b
    	DO SHARE $c $d; OD;
 	OD;




COORDINATE 	$a: Team_1,
			$b: Team_2 
	DO	COORDINATE 	$c: Take_up_covered_and_concealed_positions_to_block_any_enemy_movement_toward_breach FROM $a,
               		$d: Take_up_covered_and_concealed_positions_to_block_any_enemy_movement_toward_breach FROM $b
    	DO SHARE $c $d; OD;
 	OD;








COORDINATE 	$a: Team_1,
			$b: Team_2
	DO	COORDINATE 	$c: Engage_any_identified_or_likely_enemy_positions FROM $a,
               		$d: Engage_any_identified_or_likely_enemy_positions FROM $b
    	DO SHARE $c $d; OD;
 	OD;





COORDINATE 	$a: Team_1,
			$b: Team_2
	DO	COORDINATE 	$c: Establish_foothold FROM $a,
               		$d: Establish_foothold FROM $b
    	DO SHARE $c $d; OD;
 	OD;






COORDINATE 	$a: Team_1,
			$b: Squad_Leader
	DO	COORDINATE 	$c: Move_to_last_covered_position_near_breach_point FROM $a,
               		$d: Move_to_last_covered_position_near_breach_point FROM $b
    	DO SHARE $c $d; OD;
 	OD;


COORDINATE 	$a: Team_2,
			$b: Squad_Leader 
	DO	COORDINATE 	$c: Move_to_last_covered_position_near_breach_point FROM $a,
               		$d: Move_to_last_covered_position_near_breach_point FROM $b
    	DO SHARE $c $d; OD;
 	OD;


COORDINATE $a: Commence_suppression, $b: Move_to_last_covered_position_near_breach_point
	DO ADD $a PRECEDES $b; OD; 



COORDINATE $a: (Initiate_breach_through_explosive_means | Initiate_breach_through_mechanical_means),
 $b: (Physical_structure_partially_breached | Physical_structure_fully_breached)

	DO ADD $a PRECEDES $b; OD;



COORDINATE $a: Engage_any_identified_or_likely_enemy_positions, $b: Remain_at_entry_point_and_call_forward_next_fire_team
	DO ADD $a PRECEDES $b; OD;

/*
COORDINATE $a: Teammate_injured, $b: ( Continue_holding_positions | Aid_injured_member )
	DO ADD $a PRECEDES $b; OD;
*/

COORDINATE $a: Establish_foothold, $b: Report_to_platoon_leader
	DO ADD $a PRECEDES $b; OD;


COORDINATE $a: Report_to_platoon_leader, $b: Seize_foothold_with_remainder_of_platoon
	DO ADD $a PRECEDES $b; OD;

COORDINATE $a: Report_to_platoon_leader, $b: Receive_report_from_squad_leaders
	DO ADD $a PRECEDES $b; OD;

/*
ENSURE #Teammate_injured > 0 <-> #Aid_injured_member == 1;
*/
/*Secure objective share statements */

COORDINATE 	$a: Other_Platoon_Members,
			$b: Squad_Leader 
	DO	COORDINATE 	$c: Secure_objective FROM $a,
               		$d: Secure_objective FROM $b
    	DO SHARE $c $d; OD;
 	OD;

COORDINATE 	$a: Squad_Leader,
			$b: Team_1 
	DO	COORDINATE 	$c: Secure_objective FROM $a,
               		$d: Secure_objective FROM $b
    	DO SHARE $c $d; OD;
 	OD;

COORDINATE 	$a: Team_1,
			$b: Team_2 
	DO	COORDINATE 	$c: Secure_objective FROM $a,
               		$d: Secure_objective FROM $b
    	DO SHARE $c $d; OD;
 	OD;

/*
COORDINATE $a: Deploy_successor_fire_teams, $b: Secure_objective
	DO ADD $a PRECEDES $b; OD;
*/


/*

IF #Push_back > 0 THEN 
	COORDINATE $a: Move_to_last_covered_position_near_breach_point, $b: Deny_breach_point
		DO ADD $a PRECEDES $b; OD;

FI;
*/
IF #Deploy_successor_fire_teams > 0 THEN MARK; FI;
/*
IF #Initiate_breach_through_explosive_means > 1 THEN MARK; FI;
IF #Initiate_breach_through_mechanical_means >1 THEN MARK; FI;
*/
IF #Toss_smoke_grenade > 1 THEN MARK; FI; 

/*
IF #Teammate_injured > 0 THEN MARK; FI; 
*/
/*IF #Push_back > 0 THEN MARK; FI;
*/
IF #Toss_smoke_grenade > 1 THEN SAY ("This scenario has " #Toss_smoke_grenade " Toss_smoke_grenade events"); FI;

ATTRIBUTES {number 	
    				shortest_trace_id,
    				longest_trace_id,
    				trace_unique_id,
    				count;
			bool 	d_max, d_min;
			};





/* Create and print global reports */




/* This table shows that there are 2 maximums and 1 minimum. */
/*SHOW trace_data_summary;

*/

ATTRIBUTES	{	number 	likelihood, impact, trace_risk_score, 
    					sum_risk_score, max_risk_score, 
    					max_risk_trace_unique_number,
    					risk_score, Risk_Score;	
			};

/* Assigns attributes */

    COORDINATE $employ_smoke_grenade: Toss_smoke_grenade
	DO 	$employ_smoke_grenade.likelihood:= 0.8;
		$employ_smoke_grenade.impact:= 1;
	OD;

COORDINATE $breach_requires_explosives: Initiate_breach_through_explosive_means
	DO 	$breach_requires_explosives.likelihood:= 0.4;
		$breach_requires_explosives.impact:= 7; 
	OD;

COORDINATE $breach_mechanical_means: Initiate_breach_through_mechanical_means
	DO 	$breach_mechanical_means.likelihood:= 0.6;
		$breach_mechanical_means.impact:= 7; 
	OD;


COORDINATE $Teammate_injury: Teammate_injured
	DO 	$Teammate_injury.likelihood:= 0.4;
		$Teammate_injury.impact:= 15; 
	OD;







/* Trace Risk Table and Summary */

TABLE event_risks	{ 	TITLE ("Event Risks");
    					TABS 	string Event, 
								string Likelihood,
								string Impact,
    							string Risk_Score;
					};

CLEAR event_risks;

COORDINATE $e: $$EVENT
	
	DO 	trace_risk_score+:= ($e.likelihood*$e.impact);
		IF ($e.likelihood*$e.impact) > 0 THEN
				event_risks <|
					Event: SAY($e),
					Likelihood: SAY($e.likelihood),
					Impact: SAY($e.impact),
					Risk_Score: SAY($e.likelihood*$e.impact);
		FI;
	
		/*	If the TRACE RISK SCORE for a given trace exceeds the 
        	current global maximum risk factor value (initialized 
            at zero), then make the max risk factor THIS trace's 
            risk factor and get its trace id for the max risk trace. */
		IF  trace_risk_score > GLOBAL.max_risk_score THEN 
			GLOBAL.max_risk_score:= trace_risk_score;
			GLOBAL.max_risk_trace_unique_number:= trace_id;
		FI;
		

			/*MARK traces that have a risk factor greater than a certain value*/
/*
			IF trace_risk_score >= 4 THEN MARK; FI;
            */
	OD;

/* 	If there is a risk to the trace then show the risk table on the
	trace and say the totl trace risk. */
TABLE trace_data_summary {
TABS string     Trace_Number,
     string     Trace_Risk_Score; };

IF trace_risk_score > 0 THEN 	SHOW event_risks;
								SAY("Total Trace Risk: "trace_risk_score);
/* Create table summarizing trace data */

            
  
    	trace_data_summary     <| 
                 Trace_Number:     	SAY( trace_id ),

    			 Trace_Risk_Score: 	SAY( trace_risk_score );   
                 
FI;



/**** Calculate Total Risk ****/

/* Sum up risk scores across all traces */
GLOBAL.sum_risk_score +:= trace_risk_score;
	
GLOBAL.risk_score:= trace_risk_score;


/* Create and display Global Risk Report */

GLOBAL

REPORT Global_Risk { TITLE ( "Risk Report for Scope " $$scope ); };

/* Include these SAY statements in the Global_Risk Report */
SAY("Total risk over " #$$TRACE " traces (sum of trace risk scores): " 
        						GLOBAL.sum_risk_score) 
								=> Global_Risk;
SAY("Highest Risk: " GLOBAL.max_risk_score" (trace " 
        						GLOBAL.max_risk_trace_unique_number")") 
								=> Global_Risk;
SAY("Average Risk: " GLOBAL.sum_risk_score/#$$TRACE) 
								=> Global_Risk;
SAY("Sort by Marked to view traces with above average risk >=4.") 
								=> Global_Risk; 

SHOW Global_Risk;






/*SHOW trace_data_summary;*/

