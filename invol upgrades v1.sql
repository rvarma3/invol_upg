--M66UQW, EC4VAB, DCP73N, NWP8H6

with invol_booking as
				(
				select 
				a21.GEO_COUNTRY_CODE  GEO_COUNTRY_CODE,
				a16.pnr_sk,
				a16.ticket_sk,
				--a25.ticket_number,
				--a25.TKT_ISSUE_DATE_SK,
				a16.INBND_LOWEST_FARE_UPSELL_AED,
				a16.OUTBND_LOWEST_FARE_UPSELL_AED,
				a18.CALENDAR_DATE as departure_date,
				a16.DEPARTURE_DATE_SK,
				a19.ek_cabin as cabin_class,
				a16.CABIN_CLASS_SK,
				case when a19.ek_cabin = 'Y' then 1 when a19.ek_cabin = 'J' then 2 when a19.ek_cabin = 'F' then 3 end as coded_cabin,
				a16.INVOLUNTRY_UPGRADE_INDICATOR,
				a16.INVOLUNTRY_UPGRADE_APPROVER,
				a16.VOLUNTRY_UPGRADE_INDICATOR,
				a16.BOOKING_STATUS,
				a16.BOOKING_REFERENCE,
				a16.PNR_BOOKING_CREATION_DATE,
				a11.GEO_CITY_CODE as board_point,
				a14.GEO_CITY_CODE as off_point,
				a23.OD_PAIR  as trip_OD_PAIR,
				a22.FLIGHT_NUMBER  as op_FLIGHT_numb,
				a16.OPERATIONAL_FLIGHT_NO_SK,
				a16.OPERATIONAL_CARRIER_AIRLINE_SK,
				a24.SALES_CHANNEL_SUB_TYPE  as SALES_CHANNEL_SUB_TYPE,
				a24.AGENT_DISTRIBUTION_CHANNEL  as AGENT_DISTRIBUTION_CHANNEL,


				  the_CUST.party_sk,
				  the_CUST.NATIONALITY_CODE  ,
				  the_CUST.SKYWARDS_MEMBER_IDENTIFIER,
				  the_CUST.MEMBER_JOIN_DATE,
				  the_CUST.GENDER_CODE,
				  the_CUST.COUNTRY_OF_RESIDENCE_CODE,
				  the_CUST.LOYALTY_TIER,



				count( distinct a22.FLIGHT_NUMBER) as invol_count


				--VOLUNTRY_UPGRADE_INDICATOR
				from
				            "EDWH_PROD"."SILVER"."GEO_LOCATION"	as a11
					join	"EDWH_PROD"."SILVER"."SECTOR"	a12
					  on 	(a11.LOCATION_SK = a12.BOARD_POINT_SK)
					join	"EDWH_PROD"."SILVER"."PNR_DETAILS"	a16
					  on 	(a12.SECTOR_SK = a16.SECTOR_SK)
					join	"EDWH_PROD"."SILVER"."GEO_LOCATION"	a14
					  on 	(a12.OFF_POINT_SK = a14.LOCATION_SK)
					join	"EDWH_PROD"."SILVER"."CALENDAR_DATE"	a17
					  on 	(a16.BOOKING_DATE_SK = a17.DATE_SK)
				      join	"EDWH_PROD"."SILVER"."CALENDAR_DATE"	a18
					  on 	(a16.DEPARTURE_DATE_SK = a18.DATE_SK)
				      join	"EDWH_PROD"."SILVER"."CABIN_CLASS"	a19
				      on (a16.CABIN_CLASS_SK = a19.CABIN_CLASS_SK and a16.BOOKING_DATE_SK between a19.ISSUE_EFFECTIVE_START_DATE and a19.ISSUE_EFFECTIVE_END_DATE )
				      join	"EDWH_PROD"."SILVER"."AGENT"	a20
					  on 	(a16.POINT_OF_BOOKING_SK = a20.AGENT_SK)
					 join	"EDWH_PROD"."SILVER"."GEO_LOCATION"	a21
					  on 	(a20.GEO_LOCATION_SK = a21.LOCATION_SK)
					 join	"EDWH_PROD"."SILVER"."FLIGHT"	a22
					  on 	(a16.OPERATIONAL_FLIGHT_NO_SK = a22.FLIGHT_SK)
					join	"EDWH_PROD"."SILVER"."ORIGIN_DESTINATION"	a23
					  on 	(a16.TRIP_OD_SK = a23.OD_SK)
					  join   "EDWH_PROD"."SILVER"."SALES_CHANNEL"	a24
					  on 	(a20.SALES_CHANNEL_SK = a24.SALES_CHANNEL_SK)
					  --join "EDWH_PROD"."SILVER".flown as a25
					  --on (a16.TICKET_SK = a25.TICKET_SK and a16.PNR_SK = a25.PNR_SK and a16.FLIGHT_NUMBER)

				LEFT JOIN 
				  (
				   
				  select
				  CUST.party_sk,
				  CUST.NATIONALITY_CODE  ,
				  CUST.SKYWARDS_MEMBER_IDENTIFIER,
				  CUST.GENDER_CODE,
				  CUST.COUNTRY_OF_RESIDENCE_CODE,
				  SKWS.LOYALTY_TIER,
				  SKWS.MEMBER_JOIN_DATE

				  
				  from
				  
						  (
						  select
						  ss1.party_sk,
						  ss1.SKYWARDS_MEMBER_IDENTIFIER,
						  ss1.GENDER_CODE,
						  ss1.COUNTRY_OF_RESIDENCE_CODE,
						  ss3.NATIONALITY_CODE 
						  from
						  "EDWH_PROD"."GOLD"."CUSTOMER" as ss1
						  left join  "EDWH_PROD"."GOLD"."CUSTOMER_NATIONALITY" as ss3
						  on  (ss1.PARTY_SK = ss3.PARTY_SK)

						) as CUST 

						  JOIN 
							  (
							  select
							  ss2.SKYWARDS_MEMBER_IDENTIFIER,
							  ss2.LOYALTY_TIER,
							  ss2.MEMBER_JOIN_DATE


							  from
							  "EDWH_PROD"."GOLD"."SKYWARDS_MEMBER" as ss2 
							  )		SKWS ON CUST.SKYWARDS_MEMBER_IDENTIFIER  = SKWS.SKYWARDS_MEMBER_IDENTIFIER
				  
				  ) as the_cust ON a16.PARTY_SK = the_cust.PARTY_SK




					
					
				where
				--to_date(a18.CALENDAR_DATE) between add_months(trunc(to_date(sysdate()),'MM'),-18) and last_day(trunc(to_date(sysdate()),'MM')) and --filter is on departure date
				to_date(a18.CALENDAR_DATE) between to_date(add_months(trunc(sysdate(),'MM'),-18)) and to_date(last_day(trunc(sysdate(),'MM'))) and
				--a16.BOOKING_STATUS in ('EJ', 'EF', 'EW') and
				-- a16.INVOLUNTRY_UPGRADE_INDICATOR != 'Y' and
				a21.GEO_COUNTRY_CODE != '11' and
				a16.OPERATIONAL_CARRIER_AIRLINE_SK = 458 and
				
				1=1
				-- a16.PNR_BOOKING_CREATION_DATE = '2022-03-01'


				group by

				a21.GEO_COUNTRY_CODE,
				--a25.ticket_number,
				a16.pnr_sk,
				a16.ticket_sk,
				--a25.TKT_ISSUE_DATE_SK,
				a16.INBND_LOWEST_FARE_UPSELL_AED,
				a16.OUTBND_LOWEST_FARE_UPSELL_AED,
				a18.CALENDAR_DATE ,
				a16.DEPARTURE_DATE_SK,
				a19.ek_cabin,
				a16.CABIN_CLASS_SK,
				case when a19.ek_cabin = 'Y' then 1 when a19.ek_cabin = 'J' then 2 when a19.ek_cabin = 'F' then 3 end,
				a16.INVOLUNTRY_UPGRADE_INDICATOR,
				a16.INVOLUNTRY_UPGRADE_APPROVER,
				a16.VOLUNTRY_UPGRADE_INDICATOR,
				a16.BOOKING_STATUS,
				a16.BOOKING_REFERENCE,
				a16.PNR_BOOKING_CREATION_DATE,
				a11.GEO_CITY_CODE ,
				a14.GEO_CITY_CODE ,
				a23.OD_PAIR  ,
				a22.FLIGHT_NUMBER,
				a16.OPERATIONAL_FLIGHT_NO_SK,
				a16.OPERATIONAL_CARRIER_AIRLINE_SK,
				a24.SALES_CHANNEL_SUB_TYPE,
				a24.AGENT_DISTRIBUTION_CHANNEL,
				the_CUST.party_sk,
				  the_CUST.NATIONALITY_CODE  ,
				  the_CUST.SKYWARDS_MEMBER_IDENTIFIER,
				  the_CUST.MEMBER_JOIN_DATE,
				  the_CUST.GENDER_CODE,
				  the_CUST.COUNTRY_OF_RESIDENCE_CODE,
				  the_CUST.LOYALTY_TIER

				)

,


flown_class	as			(
				-- flown table to ascertain traveled class

								select
					flown_thing.TICKET_SK,
				    flown_thing.pnr_sk,
				    flown_thing.DEPARTURE_DATE_SK,
					flown_thing.departure_date,
					flown_thing.BOOKING_REFERENCE,
					flown_thing.FLOWN_TICKET_NUMBER,
					flown_thing.FLIGHT_DESC,
					flown_thing.OPERATIONAL_FLT_SK,
					flown_thing.TRAVELLED_CABIN_CLASS_SK,
					flown_thing.BOOKED_CABIN_CLASS_SK,
					flown_thing.CARR_CD,
					flown_thing.board_point,
					flown_thing.off_point,
					flown_thing.SALES_CHANNEL_SUB_TYPE,
					flown_thing.CREDIT_AGENT_DISTRIBUTION_CHANNEL,
					flown_thing.point_of_credit,
                    flown_thing.POS_PSEUDO_CITY_CODE,
					flown_thing.traveled_class,
					flown_thing.booked_class,
                    flown_thing.v2_trvld_class,
                    flown_thing.v2_booked_class,
                    

				  	flown_thing.party_sk,
				  	flown_thing.NATIONALITY_CODE  ,
				  	flown_thing.SKYWARDS_MEMBER_IDENTIFIER,
				  	flown_thing.MEMBER_JOIN_DATE,
				  	flown_thing.GENDER_CODE,
				  	flown_thing.COUNTRY_OF_RESIDENCE_CODE,
				  	flown_thing.LOYALTY_TIER,
					case
					when flown_thing.booked_class = 'F' then 4
					when flown_thing.booked_class = 'J' then 3
					when flown_thing.booked_class = 'W' then 2
					when flown_thing.booked_class = 'Y' then 1 end as booked_cabin_code,
					case
					when flown_thing.traveled_class = 'F' then 4
					when flown_thing.traveled_class = 'J' then 3
					when flown_thing.traveled_class = 'W' then 2
					when flown_thing.traveled_class = 'Y' then 1 end as traveled_cabin_code,

					sum(flown_thing.od_pax) as od_pax,
					sum(flown_thing.rpkm) as rpkm,
					sum(flown_thing.flown_revenue)  flown_revenue,
					count(distinct flown_thing.flt_no_cnt) as flt_no_cnt




				from

						(

						select	
						    a11.TICKET_SK,
						    a11.pnr_sk,
						    a11.FLOWN_DATE_SK  DEPARTURE_DATE_SK,
							a14.CALENDAR_DATE  departure_date,
							a13.BOOKING_REFERENCE  BOOKING_REFERENCE,
							a11.FLOWN_TICKET_NUMBER  FLOWN_TICKET_NUMBER,
							a12.FLIGHT_NUMBER  FLIGHT_DESC,
							a11.OPERATIONAL_FLT_SK,
							a11.TRAVELLED_CABIN_CLASS_SK,
							a11.BOOKED_CABIN_CLASS_SK,
							a17.CARR_CD,
							a19.GEO_CITY_CODE as board_point,
							a20.GEO_CITY_CODE as off_point,
							a22.SALES_CHANNEL_SUB_TYPE  SALES_CHANNEL_SUB_TYPE,
							a22.AGENT_DISTRIBUTION_CHANNEL  CREDIT_AGENT_DISTRIBUTION_CHANNEL,
							a24.GEO_COUNTRY_CODE  point_of_credit,
                            a13.POS_PSEUDO_CITY_CODE,


							case 
							when a15.CABIN_CLASS = 'R' then 'F'  
							when a15.CABIN_CLASS = 'C' then 'J'  
							else a15.CABIN_CLASS end as traveled_class,

							case 
							when a16.CABIN_CLASS = 'R' then 'F'  
							when a16.CABIN_CLASS = 'C' then 'J'  
							else a16.CABIN_CLASS end as booked_class,

		                    a15.EK_CLASS_OR_CABIN_CLASS as v2_trvld_class,
		                    a16.EK_CLASS_OR_CABIN_CLASS as v2_booked_class,
		                    

						  the_CUST.party_sk,
						  the_CUST.NATIONALITY_CODE  ,
						  the_CUST.SKYWARDS_MEMBER_IDENTIFIER,
						  the_CUST.MEMBER_JOIN_DATE,
						  the_CUST.GENDER_CODE,
						  the_CUST.COUNTRY_OF_RESIDENCE_CODE,
						  the_CUST.LOYALTY_TIER,


							sum(a11.FLOWN_ONLINE_OD_PAX_COUNT) as od_pax,
							sum(a11.FLOWN_ONLINE_OD_RPKM) as rpkm,
							sum(a11.FLOWN_ONLINE_OD_NET_NET_REVENUE_AED)  flown_revenue,
							count(distinct a12.FLIGHT_NUMBER) as flt_no_cnt
						from	"EDWH_PROD"."SILVER"."FLOWN"	a11
							join	"EDWH_PROD"."SILVER"."FLIGHT"	a12
							  on 	(a11.OPERATIONAL_FLT_SK = a12.FLIGHT_SK)
							join	"EDWH_PROD"."SILVER"."PNR"	a13
							 on 	(a11.PNR_SK = a13.PNR_SK and a11.booking_date = a13.pnr_booking_creation_date_sk )--and a11.OPERATIONAL_FLT_SK = a13.OPERATIONAL_FLIGHT_NO_SK )
  							join "EDWH_PROD"."SILVER"."TICKET_COUPON" as a25
		                      on (a11.TICKET_SK = a25.TICKET_SK and a11.pnr_sk = a25.pnr_sk and a11.OPERATIONAL_FLT_SK = a25.OPERATIONAL_FLIGHT_NUMBER_SK
                                 and a11.FLOWN_DATE_SK = a25.DEPARTURE_DATE_SK)
							join	"EDWH_PROD"."SILVER"."CALENDAR_DATE"	a14
							  on 	(a11.FLOWN_DATE_SK = a14.DATE_SK)
							join	"EDWH_PROD"."SILVER"."CABIN_CLASS"	a15
							 on (a11.TRAVELLED_CABIN_CLASS_SK = a15.CABIN_CLASS_SK and 
						     a11.FLOWN_DATE_SK BETWEEN a15.TRAVEL_EFFTIVE_START_DATE AND a15.TRAVEL_EFFTIVE_END_DATE)
							join	"EDWH_PROD"."SILVER"."CABIN_CLASS"	a16
						      on 	(a11.BOOKED_CABIN_CLASS_SK = a16.CABIN_CLASS_SK and a11.BOOKING_DATE between a16.ISSUE_EFFECTIVE_START_DATE and a16.ISSUE_EFFECTIVE_END_DATE)
						  	join	"EDWH_PROD"."SILVER"."AIRLINE"	a17
							  on 	(a11.OP_AIRLINE_SK = a15.AIRLINE_SK)
							join	"EDWH_PROD"."SILVER"."SECTOR"	 a18
							  on	(a11.SECTOR_SK = a18.SECTOR_SK)
							join   "EDWH_PROD"."SILVER"."GEO_LOCATION"	 a19
							  on 	(a19.LOCATION_SK = a18.BOARD_POINT_SK)
							join	"EDWH_PROD"."SILVER"."GEO_LOCATION"	a20
							  on 	(a18.OFF_POINT_SK = a20.LOCATION_SK)
							join	"EDWH_PROD"."SILVER"."AGENT"	a21
							  on 	(a11.AGENT_SK = a21.AGENT_SK)
							join	"EDWH_PROD"."SILVER"."SALES_CHANNEL"	a22
							  on 	(a21.SALES_CHANNEL_SK = a22.SALES_CHANNEL_SK)
							join	"EDWH_PROD"."SILVER"."GEO_LOCATION"	a24
							  on 	(a21.GEO_LOCATION_SK = a24.LOCATION_SK)



						  LEFT JOIN 
						  (
						   
						  select
						  CUST.party_sk,
						  CUST.NATIONALITY_CODE  ,
						  CUST.SKYWARDS_MEMBER_IDENTIFIER,
						  CUST.GENDER_CODE,
						  CUST.COUNTRY_OF_RESIDENCE_CODE,
						  SKWS.LOYALTY_TIER,
						  SKWS.MEMBER_JOIN_DATE

						  
						  from
						  
								  (
									  select
									  ss1.party_sk,
									  ss1.SKYWARDS_MEMBER_IDENTIFIER,
									  ss1.GENDER_CODE,
									  ss1.COUNTRY_OF_RESIDENCE_CODE,
									  ss3.NATIONALITY_CODE 
									  from
									  "EDWH_PROD"."GOLD"."CUSTOMER" as ss1
									  left join  "EDWH_PROD"."GOLD"."CUSTOMER_NATIONALITY" as ss3
									  on  (ss1.PARTY_SK = ss3.PARTY_SK)

									) as CUST 

									  JOIN 
									  (
									  select
									  ss2.SKYWARDS_MEMBER_IDENTIFIER,
									  ss2.LOYALTY_TIER,
									  ss2.MEMBER_JOIN_DATE
									  from
									  "EDWH_PROD"."GOLD"."SKYWARDS_MEMBER" as ss2 
									  )		SKWS ON CUST.SKYWARDS_MEMBER_IDENTIFIER  = SKWS.SKYWARDS_MEMBER_IDENTIFIER
						  
						  		) as the_cust ON a11.PARTY_SK = the_cust.PARTY_SK


						where	
						--to_date(a14.CALENDAR_DATE) between add_months(trunc(to_date(sysdate()),'MM'),-18) and last_day(trunc(to_date(sysdate()),'MM')) and  -- this is the depature date filter
						to_date(a14.CALENDAR_DATE) between to_date(add_months(trunc(sysdate(),'MM'),-18)) and to_date(last_day(trunc(sysdate(),'MM'))) and
						-- and a11.TRAVELLED_CABIN_CLASS_SK !=	a11.BOOKED_CABIN_CLASS_SK
						a17.CARR_CD = '176' and
						a15.cabin_desc is not null and
						a15.cabin_desc != 'UNKNOWN' and
						a25.coupon_status = ('F') and
						a24.GEO_COUNTRY_CODE != '11' and
                        a13.POS_PSEUDO_CITY_CODE != 'QST' and
                        a25.TICKETED_PAX_TYPE_ADULT_CHILD_INFANT != 'INFANT' and
						

						-- a15.EK_CLASS_OR_CABIN_CLASS != a16.EK_CLASS_OR_CABIN_CLASS
						 
						 1 = 1
						group by
							a11.TICKET_SK,
							a11.pnr_sk,
						    a11.FLOWN_DATE_SK,
							a14.CALENDAR_DATE,
							a13.BOOKING_REFERENCE,
							a11.FLOWN_TICKET_NUMBER,
							a12.FLIGHT_NUMBER,
							a11.OPERATIONAL_FLT_SK,
							a11.TRAVELLED_CABIN_CLASS_SK,
							a11.BOOKED_CABIN_CLASS_SK,
							a17.CARR_CD,
							a22.SALES_CHANNEL_SUB_TYPE  ,
							a22.AGENT_DISTRIBUTION_CHANNEL,
							a24.GEO_COUNTRY_CODE ,
                            a13.POS_PSEUDO_CITY_CODE,
							case 
							when a15.CABIN_CLASS = 'R' then 'F'  
							when a15.CABIN_CLASS = 'C' then 'J'  
							else a15.CABIN_CLASS end,

							case 
							when a16.CABIN_CLASS = 'R' then 'F'  
							when a16.CABIN_CLASS = 'C' then 'J'  
							else a16.CABIN_CLASS end,
						  a19.GEO_CITY_CODE,
						  a20.GEO_CITY_CODE,
						  the_CUST.party_sk,
						  the_CUST.NATIONALITY_CODE  ,
						  the_CUST.SKYWARDS_MEMBER_IDENTIFIER,
						  the_CUST.MEMBER_JOIN_DATE,
						  the_CUST.GENDER_CODE,
						  the_CUST.COUNTRY_OF_RESIDENCE_CODE,
						  the_CUST.LOYALTY_TIER,
		                  a15.EK_CLASS_OR_CABIN_CLASS,
		                  a16.EK_CLASS_OR_CABIN_CLASS

		                  	) as flown_thing
		group by
			flown_thing.TICKET_SK,
		    flown_thing.pnr_sk,
		    flown_thing.DEPARTURE_DATE_SK,
			flown_thing.departure_date,
			flown_thing.BOOKING_REFERENCE,
			flown_thing.FLOWN_TICKET_NUMBER,
			flown_thing.FLIGHT_DESC,
			flown_thing.OPERATIONAL_FLT_SK,
			flown_thing.TRAVELLED_CABIN_CLASS_SK,
			flown_thing.BOOKED_CABIN_CLASS_SK,
			flown_thing.CARR_CD,
			flown_thing.board_point,
			flown_thing.off_point,
			flown_thing.SALES_CHANNEL_SUB_TYPE,
			flown_thing.CREDIT_AGENT_DISTRIBUTION_CHANNEL,
			flown_thing.point_of_credit,
            flown_thing.POS_PSEUDO_CITY_CODE,
			flown_thing.traveled_class,
			flown_thing.booked_class,
            flown_thing.v2_trvld_class,
            flown_thing.v2_booked_class,
            

		  	flown_thing.party_sk,
		  	flown_thing.NATIONALITY_CODE  ,
		  	flown_thing.SKYWARDS_MEMBER_IDENTIFIER,
		  	flown_thing.MEMBER_JOIN_DATE,
		  	flown_thing.GENDER_CODE,
		  	flown_thing.COUNTRY_OF_RESIDENCE_CODE,
		  	flown_thing.LOYALTY_TIER,
			case
			when flown_thing.booked_class = 'F' then 4
			when flown_thing.booked_class = 'J' then 3
			when flown_thing.booked_class = 'W' then 2
			when flown_thing.booked_class = 'Y' then 1 end ,
			case
			when flown_thing.traveled_class = 'F' then 4
			when flown_thing.traveled_class = 'J' then 3
			when flown_thing.traveled_class = 'W' then 2
			when flown_thing.traveled_class = 'Y' then 1 end


				)

		,

-- emd's issued


emd_table as
		(
			select	
			a17.RFISC_CODE  RFISC_CODE,
			a17.RFISC_DESC  RFISC_DESC,
			a15.FLIGHT_NUMBER  FLIGHT_DESC,
			a11.TKT_OPERATIONAL_FLIGHT_NO_SK,
			a11.EMD_NUMBER  EMD_NUMBER,
			a11.TICKET_NUMBER  TICKET_NUMBER,
		    a11.tkt_sk,
			a15.FLIGHT_DESTINATION  origin,
			a15.FLIGHT_ORIGIN  destin,
			a11.DEPARTURE_DATE_SK  DEPARTURE_DATE_SK,
			a18.CALENDAR_DATE  departure_DATE,
			--a16.BOOKING_REFERENCE  BOOKING_REFERENCE,
			a11.PNR_SK,
			a13.APT_CITY_CODE  brd_point,
			--a13.APT_CITY_NAME  APT_CITY_NAME,
			a14.APT_CITY_CODE  off_point,
			--a14.APT_CITY_NAME  APT_CITY_NAME0,
			sum(a11.COUPON_REVENUE_AED)  emd_cpn_rev,
			count(distinct TKT_OPERATIONAL_FLIGHT_NO_SK) as flight_count
		from	    "EDWH_PROD"."SILVER"."EMD_COUPON"	a11
			join	"EDWH_PROD"."SILVER"."SECTOR"	a12
			  on 	(a11.SECTOR_SK = a12.SECTOR_SK)
			join	"EDWH_PROD"."SILVER"."GEO_LOCATION"	a13
			  on 	(a12.BOARD_POINT_SK = a13.LOCATION_SK)
			join	"EDWH_PROD"."SILVER"."GEO_LOCATION"	a14
			  on 	(a12.OFF_POINT_SK = a14.LOCATION_SK)
			join	"EDWH_PROD"."SILVER"."FLIGHT"	a15
			  on 	(a11.TKT_OPERATIONAL_FLIGHT_NO_SK = a15.FLIGHT_SK)
			--join	"EDWH_PROD"."SILVER"."PNR"	a16
			 -- on 	((a11.PNR_SK = a16.PNR_SK and a11.PNR_CREATION_DATE_SK = a16.PNR_BOOKING_CREATION_DATE_SK) )
			join	"EDWH_PROD"."SILVER"."ANCILLARY_PRODUCT"	a17
			  on 	(a11.RFISC_CODE_SK = a17.RFISC_CODE_SK)
			join	"EDWH_PROD"."SILVER"."CALENDAR_DATE"	a18
			  on 	(a11.DEPARTURE_DATE_SK = a18.DATE_SK)
		where	
		a18.CALENDAR_DATE between to_date(add_months(trunc(sysdate(),'MM'),-18)) and to_date(last_day(trunc(sysdate(),'MM'))) and
		a17.RFISC_DESC like '%UPG%' and
		--a15.FLIGHT_NUMBER = '0003' and
		1=1
		group by	
		a17.RFISC_CODE,
			a17.RFISC_DESC,
			a15.FLIGHT_NUMBER,
			a11.TKT_OPERATIONAL_FLIGHT_NO_SK,
			a11.EMD_NUMBER,
			a11.TICKET_NUMBER,
		    a11.tkt_sk,
			a15.FLIGHT_DESTINATION,
			a15.FLIGHT_ORIGIN,
			a11.DEPARTURE_DATE_SK,
			a18.CALENDAR_DATE,
			--a16.BOOKING_REFERENCE,
			a11.PNR_SK,
			a13.APT_CITY_CODE,
			--a13.APT_CITY_NAME  APT_CITY_NAME,
			a14.APT_CITY_CODE
			)


		-- join on pnr, ticket , departure date,  and flight number



,



-------mile upgrades

miles_upgade as 
				(
					select	
					a11.party_sk,
					a11.SKYWARDS_MEMBER_IDENTIFIER,
				    a11.BOOKABLE_ACTIVITY_DIFFERENTIATOR_CODE,
					-- a11.TRANSACTION_DESCRIPTION ,
					-- a12.STATEMENT_DESCRIPTION,
					a12.REWARD_IDENTIFIER,
					a11.TRANSACTION_SEQUENCE_NUMBER,
					a12.FLT_PNR_NUMBER, -- join condition
					a12.FLT_PNR_CREATION_DATE, --join condition
					a12.FLT_TICKET_NUMBER, --join condition
					a12.FLT_TICKET_ISSUE_DATE,
					to_date(a12.MEMBER_ACTIVITY_DATE) as MEMBER_ACTIVITY_DATE, --join condition

					a14.FLIGHT_DATE,
					a14.FLT_NUMBER,
					a14.ORIGIN,
					a14.DESTINATION,

					sum(SKYWARDS_MILES_NUMBER) as skywards_miles,


					count(distinct (CASE WHEN a11.TRANSACTION_SEQUENCE_NUMBER=0 THEN NULL ELSE a11.TRANSACTION_SEQUENCE_NUMBER END))  trans_count,
                    count(distinct (CASE WHEN a11.TRANSACTION_SEQUENCE_NUMBER=0 THEN NULL ELSE 1 END))  new_trans_count
					from
				           "EDWH_PROD"."GOLD"."SKYWARDS_MEMBER_ACTIVITY_TRANSACTION" as a11
					join	"EDWH_PROD"."GOLD"."SKYWARDS_MEMBERSHIP_ACTIVITY" as a12
					  on 	(a11.PARTY_MEMBERSHIP_ACTIVITY_SK = a12.PARTY_MEMBERSHIP_ACTIVITY_SK)
					join	EDWH_PROD.GOLD.SKYWARDS_MEMBER_ACTIVITY_TYPE	a13
					  on 	(a12.MEMBER_ACTIVITY_TYPE_SK = a13.MEMBER_ACTIVITY_TYPE_SK)
					 join "EDWH_PROD"."WS_SKYWARDS_PROD"."RUCH_INVOL_REW_ITN_DETAILS" a14
					 on ( a12.REWARD_IDENTIFIER = a14.RBE_RWD_ID and to_date(a12.MEMBER_ACTIVITY_DATE) = to_date(a14.MEM_ACT_DATE) )
					where
					a11.BOOKABLE_ACTIVITY_DIFFERENTIATOR_CODE like '%OWU%' and
				 	--and to_date(a12.MEMBER_ACTIVITY_DATE) between add_months(trunc(to_date(sysdate()),'MM'),-1) and last_day(trunc(to_date(sysdate()),'MM'))
				 	to_date(a14.FLIGHT_DATE) between to_date(add_months(trunc(sysdate(),'MM'),-18)) and to_date(last_day(trunc(sysdate(),'MM'))) and
				 	a13.MEMBER_ACTIVITY_TYPE_CODE = 'RMA' and
				 	a12.ACTIVITY_CANCELLED_FLAG != 'Y' and
				 	
				 	1=1
					group by	
					a11.party_sk,
					a11.SKYWARDS_MEMBER_IDENTIFIER,
				    a11.BOOKABLE_ACTIVITY_DIFFERENTIATOR_CODE,
					-- a11.TRANSACTION_DESCRIPTION ,
					-- a12.STATEMENT_DESCRIPTION,
					a12.REWARD_IDENTIFIER,
					a11.TRANSACTION_SEQUENCE_NUMBER,
					a12.FLT_PNR_NUMBER, -- join condition
					a12.FLT_PNR_CREATION_DATE, --join condition
					a12.FLT_TICKET_NUMBER, --join condition
					a12.FLT_TICKET_ISSUE_DATE,
					to_date(a12.MEMBER_ACTIVITY_DATE), --join condition

					a14.FLIGHT_DATE,
					a14.FLT_NUMBER,
					a14.ORIGIN,
					a14.DESTINATION
                    having
                    sum(abs(SKYWARDS_MILES_NUMBER)) > 0

				)


select

ss1.FLIGHT_DESC,
ss1.departure_date,
--ss1.BOOKING_REFERENCE,
sum(nvl(ss1.flt_no_cnt,0)) as total_sts_booked,
sum(nvl(upg_2.upg_count,0)) as upg_count,
sum(nvl(upg_5.cupc_upg_cnt,0)) as cupc_upg_cnt,
sum(nvl(upg_7.paid_upg_cnt,0)) as paid_upg_cnt,
sum(nvl(upg_9.mile_upg_cnt_1,0)) as miles_upg_cnt


from flown_class as ss1
left join
		(
			select
					upg_1.TICKET_SK,
				    upg_1.pnr_sk,
				    upg_1.DEPARTURE_DATE_SK,
				    upg_1.FLIGHT_DESC,
				    sum(nvl(upg_1.flt_no_cnt,0)) as upg_count
				    from
				    flown_class as upg_1
				    where
				    upg_1.traveled_cabin_code > upg_1.booked_cabin_code and
				    upg_1.departure_date between to_date(add_months(trunc(sysdate(),'MM'),-18)) and to_date(last_day(trunc(sysdate(),'MM')))
					group by
					upg_1.TICKET_SK,
				    upg_1.pnr_sk,
				    upg_1.DEPARTURE_DATE_SK,
				    upg_1.FLIGHT_DESC


		) as upg_2 on ss1.TICKET_SK = upg_2.TICKET_SK and ss1.pnr_sk = upg_2.pnr_sk and 
					  ss1.DEPARTURE_DATE_SK = upg_2.DEPARTURE_DATE_SK and ss1.FLIGHT_DESC = upg_2.FLIGHT_DESC

left join
		(
			select
					upg_3.TICKET_SK,
				    upg_3.pnr_sk,
				    upg_3.DEPARTURE_DATE_SK,
				    upg_3.FLIGHT_DESC,
				    sum(nvl(upg_3.flt_no_cnt,0)) as cupc_upg_cnt
				    from
				    flown_class as upg_3
				    join
				    invol_booking as upg_4 on upg_3.TICKET_SK = upg_4.TICKET_SK and upg_3.pnr_sk = upg_4.pnr_sk and 
					  upg_3.DEPARTURE_DATE_SK = upg_4.DEPARTURE_DATE_SK and upg_3.OPERATIONAL_FLT_SK = upg_4.OPERATIONAL_FLIGHT_NO_SK
				    where
				    upg_3.traveled_cabin_code > upg_3.booked_cabin_code and
				    upg_4.INVOLUNTRY_UPGRADE_INDICATOR = 'Y' and
				    to_date(upg_3.departure_date) between to_date(add_months(trunc(sysdate(),'MM'),-18)) and to_date(last_day(trunc(sysdate(),'MM')))
					group by
					upg_3.TICKET_SK,
				    upg_3.pnr_sk,
				    upg_3.DEPARTURE_DATE_SK,
				    upg_3.FLIGHT_DESC


		) as upg_5 on ss1.TICKET_SK = upg_5.TICKET_SK and ss1.pnr_sk = upg_5.pnr_sk and 
					  ss1.DEPARTURE_DATE_SK = upg_5.DEPARTURE_DATE_SK and ss1.FLIGHT_DESC = upg_5.FLIGHT_DESC


left join

		(

			select
			upg_6.TKT_OPERATIONAL_FLIGHT_NO_SK,
			upg_6.tkt_sk,
			upg_6.DEPARTURE_DATE_SK  DEPARTURE_DATE_SK,
			upg_6.PNR_SK,
			sum(upg_6.flight_count) as paid_upg_cnt
			from
			emd_table as upg_6
			where
			to_date(upg_6.departure_date) between to_date(add_months(trunc(sysdate(),'MM'),-18)) and to_date(last_day(trunc(sysdate(),'MM'))) and
			upg_6.RFISC_CODE not in ('02S', '01U')
			group by
			upg_6.TKT_OPERATIONAL_FLIGHT_NO_SK,
			upg_6.tkt_sk,
			upg_6.DEPARTURE_DATE_SK,
			upg_6.PNR_SK

		) as upg_7 on 	ss1.OPERATIONAL_FLT_SK = upg_7.TKT_OPERATIONAL_FLIGHT_NO_SK and ss1.TICKET_SK = upg_7.tkt_sk 
						and ss1.DEPARTURE_DATE_SK = upg_7.DEPARTURE_DATE_SK and ss1.pnr_sk = upg_7.PNR_SK

left join
			(
					select
					upg_8.FLT_PNR_NUMBER, -- join condition
					upg_8.FLT_PNR_CREATION_DATE, --join condition
					upg_8.FLT_TICKET_NUMBER, --join condition
					to_date(upg_8.MEMBER_ACTIVITY_DATE) as MEMBER_ACTIVITY_DATE, --join condition
					upg_8.FLT_NUMBER,
					upg_8.FLIGHT_DATE,
					sum(upg_8.trans_count) as mile_upg_cnt_1,
                    sum(upg_8.new_trans_count) as mile_upg_cnt_2
					from
					miles_upgade as upg_8
					where
					to_date(upg_8.MEMBER_ACTIVITY_DATE) between to_date(add_months(trunc(sysdate(),'MM'),-18)) and to_date(last_day(trunc(sysdate(),'MM')))
					group by
					upg_8.FLT_PNR_NUMBER, -- join condition
					upg_8.FLT_PNR_CREATION_DATE, --join condition
					upg_8.FLT_TICKET_NUMBER, --join condition
					upg_8.FLT_NUMBER,
					upg_8.FLIGHT_DATE,
					to_date(upg_8.MEMBER_ACTIVITY_DATE) 



			) as upg_9 on ss1.BOOKING_REFERENCE = upg_9.FLT_PNR_NUMBER and ss1.FLOWN_TICKET_NUMBER = upg_9.FLT_TICKET_NUMBER 
						and to_date(ss1.departure_date) = to_date(upg_9.FLIGHT_DATE)  and ss1.FLIGHT_DESC = upg_9.FLT_NUMBER


where
to_date(ss1.departure_date) between  trunc(to_date('2022-06-18'), 'MM') and last_day(to_date('2022-06-18')) and
--ss1.FLIGHT_DESC = '0530' and
1=1
group by
ss1.FLIGHT_DESC,
--ss1.BOOKING_REFERENCE,
ss1.departure_date