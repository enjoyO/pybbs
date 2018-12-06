package co.yiiu.pybbs.service;

import co.yiiu.pybbs.mapper.NotificationMapper;
import co.yiiu.pybbs.model.Notification;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

/**
 * Created by tomoya.
 * Copyright (c) 2018, All Rights Reserved.
 * https://yiiu.co
 */
@Service
@Transactional
public class NotificationService {

  @Autowired
  private NotificationMapper notificationMapper;

  // 查询消息
  public List<Map<String, Object>> selectByUserId(Integer userId, Boolean read, Integer limit) {
    return notificationMapper.selectByUserId(userId, read, limit);
  }

  // 查询未读消息数量
  public long countNotRead(Integer userId) {
    return notificationMapper.countNotRead(userId);
  }

  public void deleteByTopicId(Integer topicId) {
    QueryWrapper<Notification> wrapper = new QueryWrapper<>();
    wrapper.lambda()
        .eq(Notification::getTopicId, topicId);
    notificationMapper.delete(wrapper);
  }

  public void deleteByUserId(Integer userId) {
    QueryWrapper<Notification> wrapper = new QueryWrapper<>();
    wrapper.lambda()
        .eq(Notification::getTargetUserId, userId)
        .or()
        .eq(Notification::getUserId, userId);
    notificationMapper.delete(wrapper);
  }
}