


SCHEDULER.every '15s' do |job|
  data = [
          { name: 'q1', val: 400 + rand(1000) },
          { name: 'q2', val: 300 + rand(1000) },
          { name: 'q3', val: 800 + rand(1000) },
          { name: 'q4', val: 100 + rand(1000) },
          { name: 'q5', val: 500 + rand(1000) },
          { name: 'q6', val: 500 + rand(1000) },
          { name: 'q7', val: 200 + rand(1000) },
          { name: 'q8', val: 300 + rand(1000) },
          { name: 'q9', val: 400 + rand(1000) },
          { name: 'q10', val: 500 + rand(1000) }
         ]
  puts data
  send_event('demo_queues', { value: data })
end
