namespace :wow do
    desc "Queries the WoW armory and updates site users based on guild rank"
    task update_members: :environment do
        guild = WoW::Guild.find()
        members = guild.members
        User.includes(:character).find_each do |user|
            #next if user.is_admin?
            character = user.character
            if (character and character.confirmed) and guild.has_member?(character.name, character.realm)
                member = guild.get_member(character.name, character.realm)
                rank = member[:rank]

                # Rank index Rank name
                # 0          Leader
                # 1          Loremaster
                # 2          Officer
                # 3          Recruiter(?)
                # 4          Officer Alt
                # 5          Raider
                # 6          Trial Raider

                user.grant :member
                if rank <= 3 then user.grant :officer else user.revoke :officer end
                if rank <= 5 then user.grant :raider else user.revoke :raider end
                if rank == 6 then user.grant :trial else user.revoke :trial end

                if rank <= 6
                    character.role = member[:role]
                    character.spec = member[:spec]
                    character.save!
                end
            else
                user.revoke :officer
                user.revoke :member
                user.revoke :raider
                user.revoke :trial
            end
        end

        #expire_fragment(controller: 'pages', action: 'index', action_suffix: 'raid_roster')
    end
end
