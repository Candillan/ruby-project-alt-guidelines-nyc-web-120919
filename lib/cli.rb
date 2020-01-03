require_relative '../config/environment'
require 'pry'
require 'tty-prompt'

class CLI

    PROMPT = TTY::Prompt.new

    def start
        self.start_menu
    end

    def start_menu
        PROMPT.select ("Greetings! Are you an actor or a viewer?") do |menu|
            menu.choice "Actor", -> {  puts `clear`; login_menu_actor }
            menu.choice "Viewer", -> {  puts `clear`; login_menu_viewer }
        end
    end

    ### Viewer Menu Section ###

    def login_menu_viewer
        PROMPT.select ("Hello, precious viewer! Please select an option.") do |menu|
            menu.choice "Create an account", -> { puts `clear`; create_account_viewer }
            menu.choice "Login with an existing account", -> { puts `clear`; login_viewer }
            menu.choice "Exit Program"
        end
    end

    def create_account_viewer
        user_input = PROMPT.ask "Type in the account name you desire: "
        # @user = User.create(name: user_input)
        # main_menu_viewer
        found_user = User.find_by(name: user_input)
        if !found_user
            @user = User.create(name: user_input)
            puts `clear`
            main_menu_viewer
        else
            puts `clear`
            puts "Error, an account already exists with that name!"
            login_menu_viewer
        end
    end

    def login_viewer
        user_input = PROMPT.ask "Username: "
        @user = nil
        @user = User.find_by(name: user_input)
        if !@user
            puts `clear`
            puts "Error, no user found with that name."
            login_menu_viewer
        else
            puts `clear`
            main_menu_viewer
        end
    end

    def main_menu_viewer
        PROMPT.select ("Welcome to Not TKTS™, #{@user.name}! The second best place for all your Broadway shows.\nPlease select one of the below options.") do |menu|
            menu.choice "Buy tickets to a show!", -> { puts `clear`; add_show_viewer }
            # menu.choice "See a show you've bought tickets to!", -> { see_show }
            menu.choice "See your shows!", -> { puts `clear`; shows_menu_viewer }
            menu.choice "Exit the program. :("
        end
    end

    def add_show_viewer
        user_input = PROMPT.collect do
          key(:name).ask("What show are you going to see?")
        end
        found_show = Show.find_by(name: user_input[:name])
        if !found_show
            puts "No show found with that name. "
            found_show = Show.create(name: user_input[:name])
        end
        # new_show = Show.create(name: user_input[:name])
        Ticket.create(user_id: @user.id, show_id: found_show.id)
        puts `clear`
        puts "You have now bought a ticket to see #{found_show.name}!"
        main_menu_viewer
    end

    def shows_menu_viewer
        PROMPT.select ("Welcome to the shows menu!\nWhat would you like to do?") do |menu|
            menu.choice "Review a show you've seen.", -> { puts `clear`; add_review }
            menu.choice "View previously seen shows!", -> { puts `clear`; seen_shows }
            menu.choice "Un..see a show?", -> { puts `clear`; delete_show_viewer }
            menu.choice "Exit to previous menu.", -> { puts `clear`; main_menu_viewer }
        end
    end

    def your_shows
        all_tickets = Ticket.all
        temp_array = []
        all_tickets.each do |ticket|
            if ticket.user_id == @user.id
                puts "----------------"
                puts "ID: #{ticket.id}"
                puts "Viewer: #{@user.name}"  #Hard code-y, but it works!
                # puts "Show: #{ticket.show.name}"
                puts "Show: #{ticket.show.name}"
                puts "Review: #{ticket.review}"
                puts "Rating: #{ticket.rating}"
                puts "----------------"
                temp_array << ticket
            end
        end
        if temp_array == []
            puts `clear`
            puts "No shows found! Please uh, see one first?"
        end
    end

    def add_review
        self.your_shows

        id_number = PROMPT.ask('Please enter the ticket number that you would like to review/rate: ')
        found_ticket = Ticket.find_by(id: id_number)
        added_review = PROMPT.ask("Please leave a review!\n")
        found_ticket.review = added_review
        added_rating = PROMPT.ask("Please submit a rating! 1-5, please: ")
        # if added_rating > 5
        #     added_rating = 5
        # elsif added_rating <= 0
        #     added_rating = 1
        # end
        found_ticket.rating = added_rating
        found_ticket.save
        puts `clear`
        puts "Review and rating successfully saved!"
        main_menu_viewer
    end

    def seen_shows
        self.your_shows
        main_menu_viewer
    end

    def delete_show_viewer
        self.your_shows
        id_number = PROMPT.ask('Please enter the ticket number that you would like to delete: ')
        found_ticket = Ticket.find_by(id: id_number)
        
        user_input = PROMPT.yes?('Do you want to...un-see this show? (How does that even work?)')
        if user_input == true 
            found_ticket.destroy
        end
        puts `clear`
        puts "Men In Black Neuralyzer ACTIVATE! You have no longer seen that show."
        main_menu_viewer
    end

    ### Actor Menu Section ###

    def login_menu_actor
        PROMPT.select ("Hello, budding actor! Please select an option.") do |menu|
            menu.choice "Create an account", -> { puts `clear`; create_account_actor }
            menu.choice "Login with an existing account", -> { puts `clear`; login_actor }
            menu.choice "Exit Program"
        end
    end

    def create_account_actor
        user_input = PROMPT.ask "Type in the account name you desire: "
        found_actor = Actor.find_by(name: user_input)
        if !found_actor
            @actor = Actor.create(name: user_input)
            puts `clear`;
            main_menu_actor
        else
            puts `clear`
            puts "Error, an account already exists with that name!"
            login_menu_actor
        end
    end

    def login_actor
        user_input = PROMPT.ask "Username: "
        @actor = nil
        @actor = Actor.find_by(name: user_input)
        if !@actor
            puts `clear`
            puts "Error, no actors found with that name."
            login_menu_actor
        else
            puts `clear`
            main_menu_actor
        end
    end

    def main_menu_actor
        PROMPT.select ("Welcome to Not IMDB™, #{@actor.name}! The second best place for all your Broadway shows.\nPlease select one of the below options.") do |menu|
            menu.choice "Add a role to your repertoire!", -> { puts `clear`; add_show_actor }
            # menu.choice "See a show you've bought tickets to!", -> { see_show }
            menu.choice "See your roles!", -> { puts `clear`; shows_menu_actor }
            menu.choice "Exit the program. :("
        end
    end

    def add_show_actor
        user_input = PROMPT.collect do
          key(:name).ask("What show are you going to perform for?")
          key(:importance).ask("How prevalent is your role? [Lead, Secondary, Minor]")
        end
        # found_show = Show.find_by(name: user_input[:name])
        # if !found_show
        #     puts "No show found with that name. "
        #     found_show = Show.create(name: user_input[:name])
        # end
        found_show = Show.find_or_create_by(name: user_input[:name])
        Role.create(actor: @actor, show: found_show, importance: user_input[:importance])
        puts `clear`
        puts "You have now registered to act in #{found_show.name}!"
        main_menu_actor
    end

    def shows_menu_actor
        PROMPT.select ("Welcome to the shows menu!\nWhat would you like to do?") do |menu|
            menu.choice "View all of your roles!", -> { puts `clear`; actor_roles }
            menu.choice "Dramatically leave a show!", -> { puts `clear`; delete_role_actor }
            menu.choice "Exit to previous menu.", -> { puts `clear`; main_menu_actor }
        end
    end

    def your_roles
        all_roles = Role.all
        temp_array = []
        all_roles.each do |role|
            if role.actor_id == @actor.id
                puts "----------------"
                puts "ID: #{role.id}"
                puts "Actor: #{@actor.name}"  #Hard code-y, but it works!
                puts "Show: #{role.show.name}"
                puts "Importance: #{role.importance}"
                puts "----------------"
                temp_array << role
            end
        end
        if temp_array == []
            puts `clear`
            puts "No shows found! Come on, make use of that acting degree!"
        end
    end

    def actor_roles
        self.your_roles
        main_menu_actor
    end

    def delete_role_actor
        self.your_roles
        id_number = PROMPT.ask('Please enter the ticket number that you would like to delete: ')
        found_role = Role.find_by(id: id_number)
        
        user_input = PROMPT.yes?('Are you sure you want to just quit like this? This is kinda dramatic...')
        if user_input == true 
            found_role.destroy
        end
        puts `clear`
        puts "What a diva! You are no longer performing in this show."
        main_menu_actor
    end

end
