# frozen_string_literal: true

require 'application_system_test_case'

class AdminCommunityMapTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1000]

  test 'admin can load members and start both selection tools' do
    sign_in users(:admin_user)

    visit admin_root_path

    mapped_locations = Location
                       .where.not(latitude: nil)
                       .where.not(longitude: nil)
                       .count
    assert_text "#{mapped_locations} members loaded"
    assert_no_selector '[data-test-page-header]', visible: :visible
    assert_equal '24px', page.evaluate_script(<<~JS)
      getComputedStyle(document.querySelector('[data-test-page-content]')).paddingTop
    JS
    assert_link 'Map'
    assert_button 'Draw circle', disabled: false
    assert_button 'Draw polygon', disabled: false
    assert_selector '.leaflet-marker-icon'

    click_button 'Draw circle'
    assert_text 'Click the circle center, then click its outer edge.'
    assert_selector '[data-draw-shape="Circle"][aria-pressed="true"]'

    click_button 'Draw polygon'
    assert_text 'Click to add polygon corners'
    assert_selector '[data-draw-shape="Polygon"][aria-pressed="true"]'

    map = find('[data-map]')
    width = map.native.size.width
    height = map.native.size.height
    polygon_points = [
      [75, 75],
      [width - 75, 75],
      [width - 75, height - 75],
      [75, height - 75]
    ]
    (polygon_points + [polygon_points.first]).each do |x, y|
      map.execute_script(<<~JS, x, y)
        const bounds = this.getBoundingClientRect()
        this.dispatchEvent(new MouseEvent("click", {
          bubbles: true,
          clientX: bounds.left + arguments[0],
          clientY: bounds.top + arguments[1]
        }))
      JS
    end

    selection_status = find('[data-map-status]').text
    selected_count = selection_status.to_i
    assert_predicate selected_count, :positive?
    assert_match(/of #{mapped_locations} mapped members selected/, selection_status)
    assert_button 'Copy emails', disabled: false
    assert_button "Download CSV (#{selected_count})", disabled: false

    page.execute_script <<~JS
      window.__lastMapDownload = null
      HTMLAnchorElement.prototype.click = function() {
        window.__lastMapDownload = { href: this.href, download: this.download }
      }
      window.URL.revokeObjectURL = function() {}
    JS
    click_button "Download CSV (#{selected_count})"

    download = page.evaluate_script('window.__lastMapDownload')
    assert_match(/\Acommunity-members-\d{4}-\d{2}-\d{2}\.csv\z/, download.fetch('download'))
    csv = page.evaluate_async_script <<~JS
      const done = arguments[0]
      fetch(window.__lastMapDownload.href)
        .then(response => response.text())
        .then(done)
    JS
    assert_equal "Name,Email,Telegram\r\n", csv.lines.first
    assert_equal selected_count + 1, csv.lines.size

    expected_emails = CSV
                      .parse(csv.delete_prefix("\uFEFF"), headers: true)
                      .map { |row| row.fetch('Email') }
                      .join(', ')
    page.execute_script <<~JS
      window.__copiedEmails = null
      Object.defineProperty(navigator, "clipboard", {
        configurable: true,
        value: { writeText: async (text) => { window.__copiedEmails = text } }
      })
    JS
    click_button 'Copy emails'
    assert_equal expected_emails, page.evaluate_script('window.__copiedEmails')
    assert_text "Copied #{selected_count} email addresses."

    click_button 'Clear selection'
    assert_button 'Copy emails', disabled: true
    assert_button 'Download CSV', disabled: true
  end
end
