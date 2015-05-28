require 'json'

module Apportionment
  module Data
    # From the Census 2010 enumeration table.  These are the so-called
    # "actual enumeration" counts that the Supreme Court has required
    # be used for the purposes of Congressional apportionment.  For any
    # purpose where an accurate population estimate is required, the
    # Census Bureau publishes corrected figures.
    CENSUS_2010_ENUM = {"Alabama" => 4_802_982,
      "Alaska" => 721_523,
      "Arizona" => 6_412_700,
      "Arkansas" => 2_926_229,
      "California" => 37_341_989,
      "Colorado" => 5_044_930,
      "Connecticut" => 3_581_628,
      "Delaware" => 900_877,
      "Florida" => 18_900_773,
      "Georgia" => 9_727_566,
      "Hawaii" => 1_366_862,
      "Idaho" => 1_573_499,
      "Illinois" => 12_864_380,
      "Indiana" => 6_501_582,
      "Iowa" => 3_053_787,
      "Kansas" => 2_863_813,
      "Kentucky" => 4_350_606,
      "Louisiana" => 4_553_962,
      "Maine" => 1_333_074,
      "Maryland" => 5_789_929,
      "Massachusetts" => 6_559_644,
      "Michigan" => 9_911_626,
      "Minnesota" => 5_314_879,
      "Mississippi" => 2_978_240,
      "Missouri" => 6_011_478,
      "Montana" => 994_416,
      "Nebraska" => 1_831_825,
      "Nevada" => 2_709_432,
      "New Hampshire" => 1_321_445,
      "New Jersey" => 8_807_501,
      "New Mexico" => 2_067_273,
      "New York" => 19_421_055,
      "North Carolina" => 9_565_781,
      "North Dakota" => 675_905,
      "Ohio" => 11_568_495,
      "Oklahoma" => 3_764_882,
      "Oregon" => 3_848_606,
      "Pennsylvania" => 12_734_905,
      "Rhode Island" => 1_055_247,
      "South Carolina" => 4_645_975,
      "South Dakota" => 819_761,
      "Tennessee" => 6_375_431,
      "Texas" => 25_268_418,
      "Utah" => 2_770_765,
      "Vermont" => 630_337,
      "Virginia" => 8_037_736,
      "Washington" => 6_753_369,
      "West Virginia" => 1_859_815,
      "Wisconsin" => 5_698_230,
      "Wyoming" => 568_300}.freeze

    # This is the actual result of apportionment by the current
    # ("Equal Proportions") method after the 2010 census.
    SEATS_2010 = {"Alabama" => 7, "Alaska" => 1, "Arizona" => 9, "Arkansas" => 4,
      "California" => 53, "Colorado" => 7, "Connecticut" => 5, "Delaware" => 1,
      "Florida" => 27, "Georgia" => 14, "Hawaii" => 2, "Idaho" => 2,
      "Illinois" => 18, "Indiana" => 9, "Iowa" => 4, "Kansas" => 4,
      "Kentucky" => 6, "Louisiana" => 6, "Maine" => 2, "Maryland" => 8,
      "Massachusetts" => 9, "Michigan" => 14, "Minnesota" => 8,
      "Mississippi" => 4, "Missouri" => 8, "Montana" => 1, "Nebraska" => 3,
      "Nevada" => 4, "New Hampshire" => 2, "New Jersey" => 12,
      "New Mexico" => 3, "New York" => 27, "North Carolina" => 13,
      "North Dakota" => 1, "Ohio" => 16, "Oklahoma" => 5, "Oregon" => 5,
      "Pennsylvania" => 18, "Rhode Island" => 2, "South Carolina" => 7,
      "South Dakota" => 1, "Tennessee" => 9, "Texas" => 36, "Utah" => 4,
      "Vermont" => 1, "Virginia" => 11, "Washington" => 10, "West Virginia" => 3,
      "Wisconsin" => 8, "Wyoming" => 1}
    
    STATE_SYMBOL = {"Alabama" => "AL", "Alaska" => "AK", "Arizona" => "AZ",
      "Arkansas" => "AR", "California" => "CA", "Colorado" => "CO",
      "Connecticut" => "CT", "Delaware" => "DE", "Florida" => "FL",
      "Georgia" => "GA", "Hawaii" => "HI", "Idaho" => "ID",
      "Illinois" => "IL", "Indiana" => "IN", "Iowa" => "IA", "Kansas" => "KS",
      "Kentucky" => "KY", "Louisiana" => "LA", "Maine" => "ME",
      "Maryland" => "MD", "Massachusetts" => "MA", "Michigan" => "MI",
      "Minnesota" => "MN", "Mississippi" => "MS", "Missouri" => "MO",
      "Montana" => "MT", "Nebraska" => "NE", "Nevada" => "NV",
      "New Hampshire" => "NH", "New Jersey" => "NJ", "New Mexico" => "NM",
      "New York" => "NY", "North Carolina" => "NC", "North Dakota" => "ND",
      "Ohio" => "OH", "Oklahoma" => "OK", "Oregon" => "OR",
      "Pennsylvania" => "PA", "Rhode Island" => "RI", "South Carolina" => "SC",
      "South Dakota" => "SD", "Tennessee" => "TN", "Texas" => "TX",
      "Utah" => "UT", "Vermont" => "VT", "Virginia" => "VA",
      "Washington" => "WA", "West Virginia" => "WV", "Wisconsin" => "WI",
      "Wyoming" => "WY"}

    # From "Table 1. Annual Estimates of the Resident Population for the
    # United States, Regions, States, and Puerto Rico: April 1, 2010 to
    # July 1, 2014 (NST-EST2014-01)", U.S. Census Bureau, Population Div.
    # Note that DC and PR have been filtered out since they are not
    # represented in Congress.
    CENSUS_2014_EST = {
      "Alabama" => 4_849_377,
      "Alaska" => 736_732,
      "Arizona" => 6_731_484,
      "Arkansas" => 2_966_369,
      "California" => 38_802_500,
      "Colorado" => 5_355_866,
      "Connecticut" => 3_596_677,
      "Delaware" => 935_614,
      "Florida" => 19_893_297,
      "Georgia" => 10_097_343,
      "Hawaii" => 1_419_561,
      "Idaho" => 1_634_464,
      "Illinois" => 12_880_580,
      "Indiana" => 6_596_855,
      "Iowa" => 3_107_126,
      "Kansas" => 2_904_021,
      "Kentucky" => 4_413_457,
      "Louisiana" => 4_649_676,
      "Maine" => 1_330_089,
      "Maryland" => 5_976_407,
      "Massachusetts" => 6_745_408,
      "Michigan" => 9_909_877,
      "Minnesota" => 5_457_173,
      "Mississippi" => 2_994_079,
      "Missouri" => 6_063_589,
      "Montana" => 1_023_579,
      "Nebraska" => 1_881_503,
      "Nevada" => 2_839_099,
      "New Hampshire" => 1_326_813,
      "New Jersey" => 8_938_175,
      "New Mexico" => 2_085_572,
      "New York" => 19_746_227,
      "North Carolina" => 9_943_964,
      "North Dakota" => 739_482,
      "Ohio" => 11_594_163,
      "Oklahoma" => 3_878_051,
      "Oregon" => 3_970_239,
      "Pennsylvania" => 12_787_209,
      "Rhode Island" => 1_055_173,
      "South Carolina" => 4_832_482,
      "South Dakota" => 853_175,
      "Tennessee" => 6_549_352,
      "Texas" => 26_956_958,
      "Utah" => 2_942_902,
      "Vermont" => 626_562,
      "Virginia" => 8_326_289,
      "Washington" => 7_061_530,
      "West Virginia" => 1_850_326,
      "Wisconsin" => 5_757_564,
      "Wyoming" => 584_153
    }

    # 2014 estimates for DC and PR, in case you want to compute
    # apportionments where one or both receives statehood or otherwise
    # is represented in Congress.
    CENSUS_2014_DC = { "District of Columbia" => 658_893 }
    CENSUS_2014_PR = { "Puerto Rico" => 3_548_397 }
  end

  class Generic
    attr_reader :log, :seats, :nseats, :method
    def initialize(nseats, populations)
      @nseats = nseats
      @method = 'Generic'
      @log = []
    end

    # Compute representation in the Electoral College.  This is
    # the same as representation in the House of Representatives,
    # except that each state has two extra seats (representing its
    # two Senators) and the District of Columbia is represented
    # as if it were a state.
    def electoral_college
      ec_seats = @seats.dup
      unless ec_seats.has_key?("District of Columbia")
	ec_seats["District of Columbia"] = 1
      end
      ec_seats.each {|k,v| ec_seats[k] = v + 2}
      ec_seats
    end
  end

  class EqualProportions < Generic
    def initialize(nseats, populations)
      super
      @method = 'Equal Proportions Method (current law)'
      states = populations.keys

      #
      # All states start get one seat, which means their multiplier is
      # 1/sqrt(2).
      #
      @seats = states.inject({}) {|a,st| a[st] = 1; a}
      multipliers = {}
      multipliers.default = 1.0/Math.sqrt(2.0)

      #
      # Priority values depend only on the number of seats the state currently
      # has, not on the seats assigned to other states, so we only need to
      # compute them once for each seat assigned.  This computes the priorities
      # after assigning all states their initial seat.
      #
      priorities = states.inject({}) do |a,st|
	a[st] = populations[st] * multipliers[st]; a
      end

      (states.length + 1).upto(nseats).each do |current_seat|
	top_state = states.max {|a,b| priorities[a] <=> priorities[b]}
	@log << {house_seat: current_seat, state: top_state,
	  state_seat: seats[top_state] + 1, priority: priorities[top_state]}
	seats[top_state] += 1
	multipliers[top_state] = 1.0/Math.sqrt(seats[top_state] * (seats[top_state] + 1.0))
	priorities[top_state] = multipliers[top_state] * populations[top_state]
      end
    end
  end

  class FairShare < Generic
    def initialize(nseats, populations)
      super
      @method = "Fair Share Method (Hamilton's Method, Statute of 1852)"
      states = populations.keys
      total_pop = populations.values.reduce(:+) * 1.0
      pop_per_seat = total_pop / nseats
      fractional_seats = states.inject({}) do |a,st|
	a[st] = populations[st] / pop_per_seat
	a[st] = 1 if a[st] < 1
	a
      end
      current_seat = 0
      @seats = {}

      # First, give one or more seats to each state proportionally
      fractional_seats.keys.each do |st|
	int_seats = Integer(fractional_seats[st])
	@seats[st] = int_seats
	current_seat += int_seats
	fractional_seats[st] -= int_seats
      end
      
      # Second, give the remaining seats single to each state in order
      # by its remaining fractional seat.
      priority = fractional_seats.keys.sort do |a,b|
	fractional_seats[a] <=> fractional_seats[b]
      end
      current_seat.upto(nseats - 1).each do |dummy|
	st = priority.shift
	# Should never happen as a matter of arithmetic!
	raise RuntimeError if st.nil?
	@seats[st] += 1
      end
    end
  end
end
