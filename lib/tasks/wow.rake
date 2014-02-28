namespace :wow do
    desc "Queries the WoW armory and updates site users based on guild rank"
    task update_members: :environment do
        guild = WoW::Guild.find()
        members = guild.members
        User.includes(:character).find_each do |user|
            next if user.is_admin?
            character = user.character
            member = members[character.name] if character and character.confirmed
            if member
                user.grant :member
                user.grant :officer if member[:rank] <= 3
            else
                user.revoke :officer
                user.revoke :member
            end
        end
    end
end
