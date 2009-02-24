require File.dirname(__FILE__) + '/../test_helper'
class AccountTest < ActiveSupport::TestCase
  def setup
    load_accounts
    @r.connect @j
    @r.connect @k
    @r.connect @m
    @r.connect @u
  end
  
  def load_accounts
    @j,@r,@k,@m,@u = Account.find :all
  end
  
  
  def mtest_feed_destroy
    assert @j.name == 'jedzej'
    assert @r.knows? @j
    @r.report 'czekoladki', 300, [1,2,3], 2
    @r.report 'kokosy', 100, [1,3], 2
    assert @r.feeds.length == 2
    @r.feeds[0].destroy
    @r = Account.find 2
    assert @r.feeds.length == 1, 'zostały feedy'
    load_accounts
    assert_equal -50, @r.friendship(@k).saldo, 'test wyjebania nie działa'
  end
  
  def atest_saldo
    j = @r.friends[0]
    assert j.saldo == 0
    @r.report 'salami', 10, [1], 2
    load_accounts
    j = @r.friends[0]
    assert_equal -10, j.saldo
    assert_equal 10, j.account.friends[0].saldo
  end
  
  def atest_saldos
    @r.report 'wodka', 50, [1,2,3,4,5], 2
    load_accounts
    j, k, m, u = @r.friends
    assert_equal -10, j.saldo, 'jedzej'
    assert_equal -10, k.saldo, 'kraxi'
    assert_equal -10, m.saldo, 'martyna'
    assert_equal -10, u.saldo, 'ukasz'
    @j.report 'zagrycha', 10.5, [1, 2], 1
    load_accounts
    j, k, m, u = @r.friends
    assert_equal -4.75, j.saldo
    
    r = @k.friends[0]
    assert_equal 10, r.saldo, 'kraxi nie zna jędrzeja, więc nie powinien widzieć jego wpłaty dla rava'
    @k.connect @j
    load_accounts
    r = @k.friends[0]
    assert_equal 14.75, r.saldo, 'saldo rava z punktu widzenia kraxiego'
    assert_equal 14.75, @j.friends[0].saldo, 'saldo rava z punktu widzenia jedzeja'
  end
  
  def mtest_mutualsy
    load_accounts
    j, k, m, u = @r.friends
    assert_equal 0, j.saldo, 'złe saldo jedzeja'
    assert_equal 0, k.saldo, 'złe saldo kraxiego'
    assert_equal 0, m.saldo, 'złe saldo martyny'
    assert_equal 0, u.saldo, 'złe saldo jercika'
    @r.report 'kalosze', 1000.0, [1,2,3,4,5], 2
    load_accounts
    j, k, m, u = @r.friends
    assert_equal -200, j.saldo, 'złe saldo jedzeja'
    assert_equal -200, k.saldo, 'złe saldo kraxiego'
    assert_equal -200, m.saldo, 'złe saldo martyny'
    assert_equal -200, u.saldo, 'złe saldo jercika'
    @k.report 'gumofilce', 60, [2,3], 3
    load_accounts
    j, k, m, u = @r.friends
    assert_equal -200, j.saldo, 'złe saldo jedzeja'
    assert_equal -170, k.saldo, 'złe saldo kraxiego'
    assert_equal -200, m.saldo, 'złe saldo martyny'
    assert_equal -200, u.saldo, 'złe saldo jercika'
    load_accounts
    r = @j.friends[0]
    assert_equal 200, r.saldo, 'złe saldo rava wzgledem jedzeja'
    @j.connect @k
    load_accounts
    r, k = @j.friends
    assert_equal 370, r.saldo, 'złe saldo rava wzgledem jedzeja'
    assert_equal -170, k.saldo, 'złe saldo kraxiego wzgledem jedzeja'
    @m.connect @j
    load_accounts
    r, k, m = @j.friends
    assert_equal 570, r.saldo, 'złe saldo rava wzgledem jedzeja'
    assert_equal -170, k.saldo, 'złe saldo kraxiego wzgledem jedzeja'
    assert_equal -200, m.saldo, 'złe saldo martyny względem jedzeja'
    @j.report 'ziemniaki', 60, [2], 1
    load_accounts
    r, k, m = @j.friends
    assert_equal 510, r.saldo, 'złe saldo rava wzgledem jedzeja'
    assert_equal -170, k.saldo, 'złe saldo kraxiego wzgledem jedzeja'
    assert_equal -200, m.saldo, 'złe saldo martyny względem jedzeja'
  end
  
  def mtest_3friends
    @j.connect @k
    @k.report 'salami', 6, [1,2,3], 3
    
    load_accounts
    r, k = @j.friends
    assert_equal -2, r.saldo, '3 złe saldo rava wzgledem jedzeja'
    assert_equal 4, k.saldo, '3 złe saldo kraxiego wzgledem jedzeja'
    
    @r.report 'precelki', 10, 2, [4]
    load_accounts
    r, k = @j.friends
    assert_equal -2, r.saldo, '3 złe saldo rava wzgledem jedzeja'
    assert_equal 4, k.saldo, '3 złe saldo kraxiego wzgledem jedzeja'
    
    @k.connect @m
    load_accounts
    r, j, m = @k.friends
    assert_equal 8, r.saldo, '3 złe saldo rava wzgledem kraxiego'
    assert_equal -2, j.saldo, '3 złe saldo jedzeja wzgledem kraxiego'
    assert_equal -10, m.saldo, '3 złe saldo martyny wzgledem kraxiego'
    
    @m.report 'parówki', 9, [2,3,4], 4
    load_accounts
    r, j, m = @k.friends
    assert_equal 5, r.saldo, '3 złe saldo rava wzgledem kraxiego'
    assert_equal -2, j.saldo, '3 złe saldo jedzeja wzgledem kraxiego'
    assert_equal -4, m.saldo, '3 złe saldo martyny wzgledem kraxiego'
  end
  
  def test_dodawarka
    @k.connect @j
    @k.report 'pyry', 10, [2,3], 1
    @k.report 'ziemniaki', 4, [1,2], 3
    @m.connect @j
    load_accounts
    @m.mutual_friends(@j) do |mutual|
      t = Transfer.find_all_by_sponsor_id_and_sponger_id( @j.id, mutual.id)[0]
    end
    r, j = @m.friends
    assert_equal -5, r.saldo, '3 złe saldo rava wzgledem martyny'
    assert_equal 5, j.saldo, '3 złe saldo jedzeja wzgledem martyny'
    @m.connect @k
    load_accounts
    r, j, k = @m.friends
    assert_equal -7, r.saldo, '3 złe saldo rava wzgledem martyny'
    assert_equal 8, j.saldo, '3 złe saldo jedzeja wzgledem martyny'
    assert_equal -1, k.saldo, '3 złe saldo kraxiego wzgledem martyny'
  end
  
  def test_feedy
    feeds = @r.feeds.count
    report = @r.report 'zaqpek', 40, [@r.id, @m.id, @j.id, @k.id, @u.id], @r.id
    
    load_accounts
    assert_equal feeds + 1, @r.feeds.count
  end
  
  def test_autoconnection_disabled
    assert_equal false, @r.report("skarpety", 10, [@r.id, @k.id], @m.id), "Autoconnect, nie powinno to byc"
  end
end
