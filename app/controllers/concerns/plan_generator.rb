module PlanGenerator
  class AbstractMeasure
    def initialize(attributes)
      @attributes = attributes
    end

    def distance(point1, point2)
      raise "You should probably override this method!"
    end
  end

  class EuclideanDistance < AbstractMeasure
    def distance(p1,p2)
      sum_of_squares = 0
      p1.each_with_index do |p1_coord,index|
      if (@attributes.include?(index))
        sum_of_squares += (p1_coord - p2[index]) ** 2
      end
      end
      Math.sqrt( sum_of_squares )
    end
  end

  class DBscan
    def initialize(distance_measure)
      @measure = distance_measure
    end

    def neighbors(db, info, p, eps)
      neighborhood = []
      db.each do |p_prime|
        if p != p_prime && @measure.distance(p, p_prime) < eps
          neighborhood.push p_prime
        end
      end

      return neighborhood
    end

    def expand_cluster(db, info, p, cluster, c, eps, min_pts)
      cluster.push p
      if info[p] != :visited
        info[p] = :visited

        n = neighbors(db, info, p, eps)

        if n.size >= min_pts
          n.each do |p_prime|
            if not c.map{|c_prime| c_prime.include? p_prime}.include?(true) #not contained in any cluster?
              expand_cluster(db, info, p_prime, cluster, c, eps, min_pts)
            end
          end
        end
      end
      return cluster
    end

    def run(db, eps, min_pts)
      c = []
      info = Hash.new

      db.each do |p|
        if info[p] != :visited
          info[p] = :visited
          n = neighbors(db, info, p, eps)

          if n.size < min_pts
            info[p] = :noise
          else
            cluster = [p] #new cluster
            c.push cluster
            n.each do |p_prime|
              if not c.map{|c_prime| c_prime.include? p_prime}.include?(true) #not contained in any cluster?
                expand_cluster(db, info, p_prime, cluster, c, eps, min_pts)
              end
            end
          end
        end
      end
      return c
    end
  end


  def cluster shoplist # list of shop_id
    shop_price_avg = Array.new
    shoplist.each_with_index do |id,index|
      shop = Shop.find(id)
      shop_price_avg[index] = [id, shop.menus.average("price").to_i]
    end

    eps,min_pts,att = 110,0,[1]
    all_attribute_indices = att
    dbscan = DBscan.new(EuclideanDistance.new(all_attribute_indices))
    cluster_result = dbscan.run(shop_price_avg, eps, min_pts)

    cluster_result.sort_by! {|r| r.size}
    cluster_result.slice!(0..cluster_result.size-4) if cluster_result.size > 3

    cluster_result
  end

  def detail_plan result,plan_shop,plan_price_avg,plan_menu
    0.upto(result.size-1){ |i| plan_shop << result[i].transpose[0]}

    temp = []
    temp << result.collect{|c| c.transpose[1].inject(0) { |r, e| r + e }.to_f/c.size}
    0.upto(temp[0].size-1){ |i| plan_price_avg << temp[0][i]}

    plan_shop.each do |plan|
      temp = []
      plan.each do |id|
        shop = Shop.find(id)
        temp.concat(shop.menus.select("id,price").collect{|c| [c.id,c.price]})
      end
      temp.sort_by!{ |s| s[1]}
      plan_menu << temp
    end
  end

  def twosum nums,target
    i,j = 0,nums.size-1
    result = [-1,-1,-1]
    while i<j
      sum = nums[i]+nums[j]
      if sum <= target
        result = [target-sum,i,j] if target-sum < result[0] or result[0] == -1
        return result if result[0]==0
        i+=1
      else sum > target
        j-=1
      end
    end
    return result
  end

  def assign menu,target
    mindiff = [0,-1,-1,-1,-1,-1]
    0.upto(menu.size-5){ |i|
      (i+1).upto(menu.size-4){ |j|
        (j+1).upto(menu.size-3){ |k|
          result = twosum menu[k+1..-1],target-menu[i]-menu[j]-menu[k]
          break if result[0] == -1
          mindiff = [target-result[0],i,j,k,result[1]+k+1,result[2]+k+1] if mindiff[0] < target-result[0] and mindiff[0] != -1
          return mindiff if mindiff[0]==target
        }
      }
    }
    return mindiff
  end

  def legal result,check_map,day_index,menu_index
    return false if check_map[day_index][menu_index] == false
    0.upto(day_index-1) { |i|
      return false if result[i] == menu_index
    }
    return true
  end

  def five_queens result,check_map,day_index,size
    return true if day_index==size
      0.upto(size-1){ |j|
        next if !legal result,check_map,day_index,j
        result.push j
        if five_queens result,check_map,day_index+1,size
          return true
        else
          result.pop
        end
      }
    return false
  end

  def check order_menu,year,month,day,hour
    check_map = Array.new(5){ Array.new(5, true)}

    0.upto(4){ |d|
      order_menu.each_with_index do |m,index|
        t1 = Time.new(year,month,day+d,hour)
        t2 = Time.new(year,month,day+d,hour+1)
        current_order_num = 0
        menu = Menu.find(m)
        #current_order_num = Order.where('shop_id == ? and delivery_at >= ? and delivery_at <= ?', menu.shop_id,t1,t2).count
        check_map[d][index] = false if current_order_num >= menu.shop.capability
      end
    }

    result = []
    five_queens result,check_map,0,5
    result
  end

  def find_candidate order_menu,plan_menu,year,month,day,hour
    1.upto(2){ |diff|
      4.downto(0){ |i|
        cur = plan_menu.transpose[0].index(order_menu[i][0])

        break if cur-diff <0
        next if order_menu.transpose[0].index(plan_menu[cur-diff][0]) != nil

        temp = order_menu[i]
        order_menu[i] = plan_menu[cur-diff]
        result =  check order_menu.transpose[0],year,month,day,hour
        if result != nil
          order_menu = result.collect{|c| order_menu[c]}
          return true
        end
        order_menu[i] = temp
      }
    }
    return false
  end

  def plan_generate shoplist,plan_shop,plan_price_avg,plan_menu,order_menu,year,month,day,hour
    # クラスタリング
    cluster_result = cluster shoplist

    # plan_shop,plan_price_avg,plan_menuを生成
    detail_plan cluster_result,plan_shop,plan_price_avg,plan_menu

    # 提示された価格の中で最大になるメニューの組み合わせを計算する（k sum）
    0.upto(plan_shop.size-1){ |i|
      assign_result = assign plan_menu[i].transpose[1],plan_price_avg[i]*5
      if assign_result[0] < plan_price_avg[i]*4.5
        plan_shop[i] = nil
        plan_price_avg[i] = nil
        plan_menu[i] = nil
      else
        order_menu << assign_result[1..-1].collect{|c| [plan_menu[i][c][0],plan_menu[i][c][1]]}
      end
    }
    plan_shop.delete_if{|x| x==nil}
    plan_price_avg.delete_if{|x| x==nil}
    plan_menu.delete_if{|x| x==nil}


    # メニューの順番を調整（日付を確認してその店が配達できるか確認する）
    0.upto(order_menu.size-1){ |i|
      result = check order_menu[i].transpose[0],year,month,day,hour
      if result != nil
        order_menu[i] = result.collect{|c| order_menu[i][c]}
      elsif find_candidate order_menu[i],plan_menu[i],year,month,day,hour
        plan_shop[i] = nil
        plan_price_avg[i] = nil
        plan_menu[i] = nil
        order_menu[i] = nil
      end
      plan_shop.delete_if{|x| x==nil}
      plan_price_avg.delete_if{|x| x==nil}
      plan_menu.delete_if{|x| x==nil}
      order_menu.delete_if{|x| x==nil}
    }
  end
end
