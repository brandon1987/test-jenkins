module ProductsHelper
  def product_list
    items = StockItem.select(
      "code, long_description"
      )

    results = []

    results << {
      'id'           => 'TEXT',
      'text'         => '',
      'textcombined' => 'TEXT'
      }

    results << {
      'id'           => 'M1',
      'text'         => '',
      'textcombined' => 'M1'
      }

    items.each do |item|
      results << {
        'id'           => item.code,
        'text'         => item.long_description,
        'textcombined' => "[#{item.code}] #{item.long_description}"
      }
    end

    return results
  end
end
