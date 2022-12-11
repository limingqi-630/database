#include "b_plus_tree_page.h"

namespace bustub {

  /*
  * �������ܣ�
  *  �ж�ҳ�����Ƿ�ΪҶ�ӽ��
  * ���飺
  *  enum class IndexPageType { INVALID_INDEX_PAGE = 0, LEAF_PAGE, INTERNAL_PAGE }
  *  ��������b_plus_tree_page.hͷ�ļ��У�
  */
  bool BPlusTreePage::IsLeafPage() const {
    return page_type_==IndexPageType::LEAF_PAGE;
  }
  /*
  * �������ܣ�
  *  �ж�ҳ�����Ƿ�Ϊ�����
  * ���飺
  *  static constexpr int INVALID_PAGE_ID = -1;// invalid page id��������config.h�У�
  *  ���ڵ�pageIdΪINVALID_PAGE_IDʱ��Ϊ�����
  */
  bool BPlusTreePage::IsRootPage() const {
      return parent_page_id_==INVALID_PAGE_ID;
  }
  /*
  * �������ܣ�
  *    ��������ҳ����
  */
  void BPlusTreePage::SetPageType(IndexPageType page_type) 
  {  
    page_type_=page_type;
  }

  /*
  * �������ܣ�
  *  get/set size (size����ǰ����д�ŵ�Ԫ�أ���ֵ�ԣ�����)
  *  IncreaseSize ���ӽ��Ԫ�ش�С
  */
  int BPlusTreePage::GetSize() const 
  { 
    return size_;

  }
  void BPlusTreePage::SetSize(int size) 
  {
    size_ = size;
    return;
  }
  void BPlusTreePage::IncreaseSize(int amount) {
    size_ += amount;
  }

  /*
  * �������ܣ�
  *  get/set max size
  */
  int BPlusTreePage::GetMaxSize() const 
  {  
    return max_size_;

  }
  void BPlusTreePage::SetMaxSize(int size) 
  {
    max_size_=size;  
  }

  /*
  * �������ܣ�
  *  ��ȡ��ǰ������������Ԫ�ظ���
  * ���飺
  *  1.�����ʱΪ���ڵ㣺���ڵ�������ڲ��ڵ�Ҳ������Ҷ�ӽڵ�
  *  �ڲ��ڵ㣺��ʱ���ٴ�����������
  *  Ҷ�ӽڵ㣺��ʱ���ٴ���һ����¼
  *  2.�Ǹ����������������Ҫ���ǰ�������
  *    �����Ҷ��㣬[(max_size_-1)/2]=(max_size_-1+1)/2
  *    ������ڲ���㣬��һ��key�ǲ�ʹ�õģ�(max_size_-1-1+1)/2+1
  */
  int BPlusTreePage::GetMinSize() const 
  {
    if(IsRootPage())                              //�Ǹ��ڵ�
    {
        if(IsLeafPage()) return 1;                //��Ҷ�ӽڵ�
        else return 2;                            //���ڲ��ڵ�
    }
    else                                          //���Ǹ��ڵ�
    {
        if(IsLeafPage()) return (max_size_-1+1)/2;//Ҷ�ӽڵ�
        else return (max_size_-1-1+1)/2+1;        //�ڲ��ڵ�
        // return (max_size_+1)/2;

    }
  }

  /*
  *�������ܣ�
  *  get/set parent page id
  * ��ʾ��
  *  1.���ý��ĸ��ڵ㷽��ֻ��ͨ��SetParentPageId��ʵ�� 
  */
  page_id_t BPlusTreePage::GetParentPageId() const 
  {  
      return parent_page_id_;
  }
  void BPlusTreePage::SetParentPageId(page_id_t parent_page_id) 
  {  
    parent_page_id_=parent_page_id;
  }

  /*
  *�������ܣ�
  *  get/set self page id
  */
  page_id_t BPlusTreePage::GetPageId() const 
  {  
    return page_id_;
  }

  void BPlusTreePage::SetPageId(page_id_t page_id) 
  {  
    page_id_=page_id;
  }


  /*
  *�������ܣ�
  * set lsn
  */
  void BPlusTreePage::SetLSN(lsn_t lsn) 
  {  
    lsn_ = lsn;  
  }

}
