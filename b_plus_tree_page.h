#pragma once

#include <cassert>
#include <climits>
#include <cstdlib>
#include <string>

#include "buffer/buffer_pool_manager.h"
#include "storage/index/generic_key.h"

namespace bustub {

#define MappingType std::pair<KeyType, ValueType>

#define INDEX_TEMPLATE_ARGUMENTS template <typename KeyType, typename ValueType, typename KeyComparator>

/* ������������
*  
*
* 
*/
enum class IndexPageType { INVALID_INDEX_PAGE = 0, LEAF_PAGE, INTERNAL_PAGE };

/**
 * �ڲ�����Ҷ�����̳��Ըý��
 *
 * BPlusTreePage�洢��Page���data�У�����Page���ײ�
 */
class BPlusTreePage {
 public:
  
  bool IsLeafPage() const;
  bool IsRootPage() const;
  void SetPageType(IndexPageType page_type);

  int GetSize() const;
  void SetSize(int size);
  void IncreaseSize(int amount);

  int GetMaxSize() const;
  void SetMaxSize(int max_size);
  int GetMinSize() const;

  page_id_t GetParentPageId() const;
  void SetParentPageId(page_id_t parent_page_id);

  page_id_t GetPageId() const;
  void SetPageId(page_id_t page_id);

  void SetLSN(lsn_t lsn = INVALID_LSN);

 private:
  //ҳ������,ȡֵenum IndexPageType
  IndexPageType page_type_ __attribute__((__unused__));
  //��־���кţ����ڲ�������
  lsn_t lsn_ __attribute__((__unused__));
  //һ��ҳ��ļ�ֵ������
  int size_ __attribute__((__unused__));
  //һ��ҳ��ļ�ֵ���������
  int max_size_ __attribute__((__unused__));
  //������ҳID�����ڵ���û�и��ڵ㣬���Զ�����ڵ��parent_page_id_=INVALID_PAGE_ID
  //������config.h,static constexpr int INVALID_PAGE_ID = -1;
  page_id_t parent_page_id_ __attribute__((__unused__));
  //������id
  page_id_t page_id_ __attribute__((__unused__));
};

}
