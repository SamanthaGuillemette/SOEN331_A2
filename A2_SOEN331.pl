%% =============================================================================
%%
%%  CONCORDIA UNIVERSITY
%%  Department of Computer Science and Software Engineering
%%  SOEN 331-U:  Assignment 2
%%  Winter term, 2020
%%  Date submitted: Tuesday, March 3rd, 2020
%%
%%  Authors:
%%
%%  Martin Marcos, 40041398
%%  Samantha Guillemette 26609198
%%  Deepkumar Patel 40096716
%%
%% =============================================================================

%% =============================================================================
%%
%%  Facts
%%  Top level states
state(idle).
state(parked_mode).
state(manual_mode).
state(cruise_mode).
state(marked_mode).
state(panic_mode).

%%  States under manual mode state
state(running).
state(faster).
state(break_mode).
state(slower).

%%  States under cruise mode state
state(tailing_mode).
state(changing_lane_mode).
state(navigation_mode).

%%  States under tailing mode state
state(accelerate).
state(decelerate).
state(tail_start).

%%  States under changing lane mode state
state(maintain_car_speed).
state(lane_start).

%%  States under navigation mode state
state(turn_left).
state(turn_right).
state(turn_left_ahead).
state(turn_right_ahead).
state(destination_ahead).
state(arrived_desination).
state(navigation_start).

%% Super states
superstate(manual_mode, running).
superstate(manual_mode, faster).
superstate(manual_mode, slower).
superstate(manual_mode, break_mode).
superstate(manual_mode, parked_mode).
superstate(manual_mode, panic_mode).
superstate(cruise_mode, tailing_mode).
superstate(cruise_mode, changing_lane_mode).
superstate(cruise_mode, navigation_mode).
superstate(tailing_mode, accelerate).
superstate(tailing_mode, decelerate).
superstate(tailing_mode, change_lane_mode).
superstate(tailing_mode, tail_start).
superstate(changing_lane_mode, maintain_car_speed).
superstate(changing_lane_mode, tailing_mode).
superstate(changing_lane_mode, lane-start).
superstate(changing_lane_mode, changing_lane_mode).
superstate(changing_lane_mode, cruise_mode).
superstate(changing_lane_mode, panic_mode).
superstate(navigation_mode, turn_left).
superstate(navigation_mode, turn_right).
superstate(navigation_mode, turn_left_ahead).
superstate(navigation_mode, turn_right_ahead).
superstate(navigation_mode, changing_lane_ahead).
superstate(navigation_mode, destination_ahead).
superstate(navigation_mode, arrived_destination).
superstate(navigation_mode, navigation_start).


%% Initial states
initial_state(idle,null).
initial_state(parked_mode, null).
initial_state(manual_mode, running).
initial_state(cruise_mode, tailing_mode).
initial_state(cruise_mode, changing_lane_mode).
initial_state(marked_mode, null).
initial_state(panic_mode, null).
initial_state(tailing_mode , tail_start).
initial_state(changing_lane_mode , lane_start).
initial_state(navigation , navigation_start).

%% Transitions within the top-level
transition(idle, parked_mode, start_car, null, system_start).
transition(idle, parked_mode, start_car, null, engine_idle).
transition(parked_mode, exit, engine_off, null, system_off).
transition(parked_mode, manual_mode, drive_signal, engine_idle, null).
transition(parked_mode, manual_mode, cruise_signal, not_set, beep).
transition(parked_mode, cruise_mode, cruise_signal, set, beep).
transition(manual_mode, cruise_mode , switch, set_dest, null).
transition(cruise_mode, manual_mode, switch, null, null).
transition(manual_mode, marked_mode,marked_mode_signal, car_stopped, null).
transition(manual_mode, parked_mode, parked_mode_signal, car_stopped, null).
transition(manual_mode, panic_mode, panic_on , null , stop_car).
transition(manual_mode, panic_mode, panic_on , null , hazard_signals_on).
transition(cruise_mode, panic_mode, unforseen, null, stop_car).
transition(cruise_mode, panic_mode, unforseen, null, hazard_signals_on).
transition(cruise_mode, parked_mode, arrived, null, null).
transition(panic_mode, parked_mode, panic_off, null, hazard_signals_off).

%% Transitions within the manual mode state
transition(running, faster, accelerate , null , increase_speed).
transition(running, break_mode, break, null , o_speed).
transition(running, slower, decelerate , null , decrease_speed).
transition(slower, faster, accelerate , null , increase_speed).
transition(faster, slower, deccelerate , null , decrease_speed).
transition(slower, break_mode, decelerate , null , decrease_speed).
transition(break_mode, running, accelerate , null , increase_speed).
transition(break_mode, parked_mode, parked_mode_signal, null, null).
transition(panic_mode, parked_mode, panic_off, null, hazard_signals_off).
transition(running, panic_mode, panic_on , null , [stop_car, hazard_signals_on]).

%% Transitions within the cruise mode state
transition(tailing_mode, changing_lane_mode, t_to_c, null, null).
transition(changing_lane_mode, tailing_mode, c_to_t, null, null).
transition(changing_lane_mode, navigation_mode, c_to_n, null, null).
transition(navigation_mode, changing_lane_mode, n_to_c, null, null).

%% Transitions within the tailing mode state
transition(tail_start,accelerate,null, slessthanminSpeedRange, null).
transition(tail_start,decelerate,null, sgreaterthanminSpeedRange, null).
transition(tail_start,decelerate,null, dlessthanminDistance, null).
transition(tail_start,changing_lane_mode,obstacle, dlessthanminDistance,  [t_to_c, switch_lane]).
transition(tail_start,changing_lane_mode,null, sbetweenminSpeedRangeandmaxSpeedRange,  [t_to_c, maintain_speed]).
transition(accelerate,accelerate,null, slessthanminSpeedRange, null).
transition(changing_lane_mode,accelerate,null, slessthanminSpeedRange, null).
transition(decelerate,accelerate,null, slessthanminSpeedRange, null).
transition(decelerate,decelerate,null, sgreaterthanminSpeedRange, null).
transition(decelerate,decelerate,null, dlessthanminDistance, null).
transition(accelerate,decelerate,null, sgreaterthanminSpeedRange, null).
transition(accelerate,decelerate,null, dlessthanminDistance, null).
transition(changing_lane_mode,decelerate,null, sgreaterthanminSpeedRange, null).
transition(changing_lane_mode,decelerate,null, dlessthanminDistance, null).




%% Transitions within the changing lane mode state
transition(lane_start, maintain_car_speed, maintain_speed ,dgreaterequalDistance, null).
transition(lane_start, tailing_mode, maintain_speed ,dlessDistance, c_to_t).
transition(lane_start, tailing_mode, maintain_speed ,sgreatermaxSRandslessSR, c_to_t).
transition(maintain_car_speed, maintain_car_speed, maintain_speed ,dgreaterequalDistance, null).
transition(maintain_car_speed, tailing_mode, null ,dlessDistance, c_to_t).
transition(maintain_car_speed, tailing_mode, null ,sgreatermaxSRandslessSR, c_to_t).
transition(lane_start, changing_lane_mode, switch_lane, car_not_in_t, null).
transition(lane_start, cruise_mode, switch_lane, car_in_t, c_to_n).
transition(lane_start, panic_mode, [switch_lane, unforseen], null, [stop_car, hazard_signal_on]).
transition(changing_lane_mode, changing_lane_mode, switch_lane, car_not_in_t, null).
transition(changing_lane_mode, cruise_mode, switch_lane, car_in_t, c_to_n).
transition(changing_lane_mode, panic_mode, [switch_lane, unforseen], null, [stop_car, hazard_signal_on]).


%% Transitions within the navigation state
transition(navigation_start, turn_left_ahead, tla, car_not_in_t, null).
transition(navigation_start, turn_right_ahead, tra, car_not_in_t, null).
transition(turn_left_ahead, changing_lane_mode, null, null, n_to_c).
transition(turn_left_ahead, changing_lane_mode, null, null, switch_lane).
transition(turn_right_ahead, changing_lane_mode, null, null, n_to_c).
transition(turn_right_ahead, changing_lane_mode, null, null, switch_lane).
transition(navigation_start, destination_ahead, d_ahead,null, car_in_t).
transition(navigation_start, destination_ahead, d_ahead,null, dest_ahead).
transition(navigation_start, turn_left, d_on_left ,null, turn_left).
transition(navigation_start, turn_right, d_on_right,null, turn_right).
transition(destination_ahead, navigation_start, null,null, null).
transition(destination_ahead, arrived_destination, car_at_d, null, arrived).



%%=============================================================================

%% =============================================================================
%%
%%  Rules
%% 1) Rule transition receives two states (at the same level of
%% abstraction), and succeeds if there is transition between them. It
%% will capture and display all <event, guard, action> triplets that are
%% associated with the transition.
%%
%% 2) Rule interface succeeds by obtaining a collection of all unique
%% <state, event> pairs in the entire system.
%%
%% =============================================================================
%%
%%
%%
%%

transitions(State1, State2):- findall([Event, Guard, Action],transition(State1, State2, Event, Guard, Action), List), write(List).

interface(State, Event):- findall([State, Event], transition(State, _, Event, _, _), Collection), write(Collection).



%% eof
