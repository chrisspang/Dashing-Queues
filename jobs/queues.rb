


SCHEDULER.every '15s' do |job|
  data = [
          { name: 'queue1', val: 400 + rand(1000) },
          { name: 'queue2', val: 300 + rand(1000) },
          { name: 'queue3', val: 800 + rand(1000) },
          { name: 'queue4', val: 100 + rand(1000) },
          { name: 'queue5', val: 500 + rand(1000) }
         ]
  puts data
  send_event('demo_queues', { value: data })
end
