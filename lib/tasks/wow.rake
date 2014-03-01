namespace :wow do
    desc "Queries the WoW armory and updates site users based on guild rank"
    task update_members: :environment do
        guild = WoW::Guild.find()
        members = guild.members
        User.includes(:character).find_each do |user|
            next if user.is_admin?
            character = user.character
            if (character and character.confirmed) and guild.has_member?(character.name, character.realm)
                user.grant :member
                user.grant :officer if guild.get_member(character.name, character.realm)[:rank] <= 3
            else
                user.revoke :officer
                user.revoke :member
            end
        end
    end
end
