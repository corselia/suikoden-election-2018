class HelloController < ApplicationController
  before_action :sample_method, only: [:index]

  def index
    rows = [
      [
        'Alvin',
        'Eclair',
        '$0.87',
      ],
      [
        'Alan',
        'Jellybean',
        '$3.76',
      ],
      [
        'Jonathan',
        'Lollipop',
        '$7.00',
      ],
      [
        'Shannon',
        'Eclair',
        "$#{sample_method}.00",
      ],
      [
        HogeFuga::SITE_NAME,
        HogeFuga::My_site_name,
        "$#{sample_method}.00",
      ],
    ]

    @return_value = rows
  end

  private
  def sample_method
    a = 1
    b = 2

    a + b
  end
end
