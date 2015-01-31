module CharactersHelper
    def cache_key_for_raid_roster
        max_updated_at = Character.maximum(:updated_at).try(:utc).try(:to_s, :number)
        "characters/raid-roster-#{max_updated_at}"
    end
end
