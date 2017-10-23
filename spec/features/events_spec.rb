require 'rails_helper'

RSpec.feature 'Event', type: :feature do
  let(:user) { create(:user) }
  let(:second_user) { create(:second_user) }
  let(:event) { create(:today_event) }
  let(:tomorrow_event) { create(:tomorrow_event) }
  let(:yesterday_event) { create(:yesterday_event) }
  let(:visited_event) { create(:visited_event) }

  before { login_as(user, scope: :user) }

  context 'creates new event' do
    context 'can\'t create event' do
      scenario 'without name' do
        visit new_event_path

        click_on 'Create Event'

        expect(Event.all.size).to eq(0)
        expect(page).to have_text('Please review the problems below:')
        expect(page).to have_text('can\'t be blank')
      end
    end

    scenario 'without visited flag' do
      visit new_event_path

      fill_in 'Name', with: 'Test Event'
      click_on 'Create Event'

      expect(Event.all.size).to eq(1)
      expect(page).to have_text('Event was successfully created.')
      expect(page).to have_text('Name: Test Event')
      expect(page).to have_text('Visited: No')
    end

    scenario 'with visited flag' do
      visit new_event_path

      fill_in 'Name', with: 'Test Event'
      find('#event_visited_flag').click
      click_on 'Create Event'

      expect(page).to have_text('Event was successfully created.')
      expect(page).to have_text('Name: Test Event')
      expect(page).to have_text('Visited: Yes')
    end
  end

  context 'edits event' do
    before { event }

    scenario 'update all fields' do
      visit edit_event_path(event)

      fill_in 'Name', with: 'Test Event Edited'
      find('#event_visited_flag').click
      find(:xpath, '//select[@id="event_date_1i"]/option[.="2017"]').select_option
      find(:xpath, '//select[@id="event_date_2i"]/option[.="July"]').select_option
      find(:xpath, '//select[@id="event_date_3i"]/option[.="10"]').select_option

      click_on 'Update Event'

      expect(page).to have_text('Event was successfully updated.')
      expect(page).to have_text('Name: Test Event Edited')
      expect(page).to have_text('Date:  2017-07-10')
      expect(page).to have_text('Visited: Yes')
    end
  end

  context 'check filters', js: true do
    scenario 'all filters' do
      user.events << event
      user.events << tomorrow_event
      user.events << yesterday_event
      user.events << visited_event

      visit root_path

      expect(page).to have_xpath('//td[.="Today event"]')
      expect(page).to have_xpath('//td[.="Tomorrow event"]')
      expect(page).to have_xpath('//td[.="Yesterday event"]')
      expect(page).to have_xpath('//td[.="Visited event"]')

      find('#visited-events').click

      expect(page).not_to have_xpath('//td[.="Today event"]')
      expect(page).not_to have_xpath('//td[.="Tomorrow event"]')
      expect(page).not_to have_xpath('//td[.="Yesterday event"]')
      expect(page).to have_xpath('//td[.="Visited event"]')

      find('#not-visited-events').click

      expect(page).to have_xpath('//td[.="Today event"]')
      expect(page).to have_xpath('//td[.="Tomorrow event"]')
      expect(page).to have_xpath('//td[.="Yesterday event"]')
      expect(page).not_to have_xpath('//td[.="Visited event"]')

      find('#past-events').click

      expect(page).not_to have_xpath('//td[.="Today event"]')
      expect(page).not_to have_xpath('//td[.="Tomorrow event"]')
      expect(page).to have_xpath('//td[.="Yesterday event"]')
      expect(page).not_to have_xpath('//td[.="Visited event"]')

      find('#feature-events').click

      expect(page).not_to have_xpath('//td[.="Today event"]')
      expect(page).to have_xpath('//td[.="Tomorrow event"]')
      expect(page).not_to have_xpath('//td[.="Yesterday event"]')
      expect(page).not_to have_xpath('//td[.="Visited event"]')

      find('#all-events').click

      expect(page).to have_xpath('//td[.="Today event"]')
      expect(page).to have_xpath('//td[.="Tomorrow event"]')
      expect(page).to have_xpath('//td[.="Yesterday event"]')
      expect(page).to have_xpath('//td[.="Visited event"]')
    end
  end

  context 'update event\'s users', js: true do
    scenario 'add new user' do
      second_user
      user.events << event
      visit root_path

      find(:xpath, '//a[.="Users"]').click

      expect(page).to have_text('Users')

      find(:xpath, '//option[.="user2@test.com"]').select_option
      click_on 'Add users'

      expect(page).to have_xpath('//option[.="user2@test.com"][@selected]')
      expect(event.users.size).to eq(2)

      logout(user)
      login_as(second_user, scope: :second_user)
      visit root_path

      expect(page).to have_xpath('//td[.="Today event"]')
    end
  end
end
