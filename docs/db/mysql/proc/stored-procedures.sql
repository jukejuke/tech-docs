-- MySQL 存储过程示例 - 包含两个游标定义
-- 功能：查询并处理用户订单数据

DELIMITER //

CREATE PROCEDURE process_user_orders()
BEGIN
    -- 声明变量
    DECLARE v_user_id INT;
    DECLARE v_username VARCHAR(100);
    DECLARE v_order_id INT;
    DECLARE v_order_amount DECIMAL(10,2);
    DECLARE v_total_orders INT DEFAULT 0;
    DECLARE v_total_amount DECIMAL(10,2) DEFAULT 0;
    DECLARE done1 BOOLEAN DEFAULT FALSE;
    DECLARE done2 BOOLEAN DEFAULT FALSE;
    
    -- 第一个游标：获取所有用户
    DECLARE user_cursor CURSOR FOR
        SELECT id, username FROM users WHERE active = 1;
    
    -- 第二个游标：获取指定用户的订单
    DECLARE order_cursor CURSOR FOR
        SELECT id, amount FROM orders WHERE user_id = v_user_id;
    
    -- 游标结束处理
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done1 = TRUE;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done2 = TRUE;
    
    -- 开始处理
    OPEN user_cursor;
    
    user_loop:
    LOOP
        FETCH user_cursor INTO v_user_id, v_username;
        IF done1 THEN
            LEAVE user_loop;
        END IF;
        
        -- 重置订单计数器
        SET v_total_orders = 0;
        SET v_total_amount = 0;
        
        -- 打开第二个游标处理订单
        OPEN order_cursor;
        
        order_loop:
        LOOP
            FETCH order_cursor INTO v_order_id, v_order_amount;
            IF done2 THEN
                SET done2 = FALSE; -- 重置标志
                LEAVE order_loop;
            END IF;
            
            -- 累加订单数据
            SET v_total_orders = v_total_orders + 1;
            SET v_total_amount = v_total_amount + v_order_amount;
        END LOOP order_loop;
        
        CLOSE order_cursor;
        
        -- 输出用户订单统计
        SELECT CONCAT('用户 ', v_username, ' 共有 ', v_total_orders, ' 个订单，总金额：', v_total_amount) AS user_order_summary;
    
    END LOOP user_loop;
    
    CLOSE user_cursor;
    
END //

DELIMITER ;

-- 存储过程使用说明：
-- 1. 确保存在 users 表（包含 id, username, active 字段）
-- 2. 确保存在 orders 表（包含 id, user_id, amount 字段）
-- 3. 调用方式：CALL process_user_orders();

-- 游标定义说明：
-- 1. user_cursor：遍历所有活跃用户，获取用户ID和用户名
-- 2. order_cursor：根据当前用户ID，获取该用户的所有订单信息