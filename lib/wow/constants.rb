module WoW
    module Constants
        CLASS_ARRAY = [:warrior, :paladin, :hunter, :rogue, :priest, :death_knight, :shaman, :mage, :warlock, :monk, :druid]

        CLASS_DATA = {
            warrior:      { id:  1, mask:    1, power: :rage        },
            paladin:      { id:  2, mask:    2, power: :mana        },
            hunter:       { id:  3, mask:    4, power: :focus       },
            rogue:        { id:  4, mask:    8, power: :energy      },
            priest:       { id:  5, mask:   16, power: :mana        },
            death_knight: { id:  6, mask:   32, power: :runic_power },
            shaman:       { id:  7, mask:   64, power: :mana        },
            mage:         { id:  8, mask:  128, power: :mana        },
            warlock:      { id:  9, mask:  256, power: :mana        },
            monk:         { id: 10, mask:  512, power: :energy      },
            druid:        { id: 11, mask: 1024, power: :mana        }
        }

        CLASS_IDS = {
             1 => :warrior,
             2 => :paladin,
             3 => :hunter,
             4 => :rogue,
             5 => :priest,
             6 => :death_knight,
             7 => :shaman,
             8 => :mage,
             9 => :warlock,
            10 => :monk,
            11 => :druid
        }

        def class_from_id(id)
            CLASS_IDS[id]
        end

        def class_data_from_id(id)
            CLASSES[class_from_id(id)]
        end
    end
end
