#include <sstream>

#include "common/exception.h"
#include "common/rid.h"
#include "storage/page/b_plus_tree_leaf_page.h"
#include "storage/page/b_plus_tree_internal_page.h"

namespace bustub {

/**
 * �������ܣ�
 *  ��ʼ��thisҳ������page type,size,page id,parent id and max page size
 */
INDEX_TEMPLATE_ARGUMENTS
void B_PLUS_TREE_LEAF_PAGE_TYPE::Init(page_id_t page_id, page_id_t parent_id, int max_size) {
    SetPageType(IndexPageType::LEAF_PAGE);
    SetSize(0);
    SetPageId(page_id);
    SetParentPageId(parent_id);
    SetMaxSize(max_size);
    SetNextPageId(INVALID_PAGE_ID);
}

/**
 * �������ܣ�
 *  ��ȡ����Ҷ�ӽڵ��page_id
 * ���飺
 *  next_page_id_����
 */
INDEX_TEMPLATE_ARGUMENTS
page_id_t B_PLUS_TREE_LEAF_PAGE_TYPE::GetNextPageId() const 
{         
    return next_page_id_;
}
/**
 * �������ܣ�
 *  ��������Ҷ�ӽڵ��page_id
 * ���飺
 *  next_page_id_����
 */
INDEX_TEMPLATE_ARGUMENTS
void B_PLUS_TREE_LEAF_PAGE_TYPE::SetNextPageId(page_id_t next_page_id) 
{ 
    next_page_id_=next_page_id;
}

/**
 * �������ܣ�
 *  ��keyֵ�������е������У��ҵ��ض�keyֵ��Ӧ��index
 * ���飺
 *  1.�����ǰ�ڵ��в�����keyֵ(size==0)������Է����׽��
 *  2.���keyֵ�����ڣ�����Ӧ�����index��λ��
 */
INDEX_TEMPLATE_ARGUMENTS
int B_PLUS_TREE_LEAF_PAGE_TYPE::KeyIndex(const KeyType &key, const KeyComparator &comparator) const {
  //�����ǰ�ڵ��в�����keyֵ�������ֱ�Ӳ��뵽��һ�����
	if (GetSize() == 0) return 0;
    for(int i=0;i<GetSize();i++)
    {
        if(comparator(array_[i].first,key)>=0)
            return i;
    }
}

/**
 * �������ܣ�
 *  ����index����keyֵ
 * ���飺
 *  1.������Ԫ��Ϊpair��firstΪkey��secondΪRID
 */
INDEX_TEMPLATE_ARGUMENTS
KeyType B_PLUS_TREE_LEAF_PAGE_TYPE::KeyAt(int index) const {
  return array_[index].first;
}


/**
 * �������ܣ�
 *  ����index����Ԫ��
 * ���飺
 *  1.������Ԫ��Ϊpair��firstΪkey��secondΪRID
 */
INDEX_TEMPLATE_ARGUMENTS
const MappingType &B_PLUS_TREE_LEAF_PAGE_TYPE::GetItem(int index) {
  return array_[index];
}

/*****************************************************************************
 *����
 *****************************************************************************/
/**
 * �������ܣ�
 *  �ڱ�֤���������²����µļ�ֵ��
 * ���飺
 *  1.Ԫ�������������账�������������ⲿ����
 *  2.��sizeΪ0ʱ���뵽����ͷ��
 *  3.����size�����ص�ǰsize��С
 */
INDEX_TEMPLATE_ARGUMENTS
int B_PLUS_TREE_LEAF_PAGE_TYPE::Insert(const KeyType &key, const ValueType &value, const KeyComparator &comparator) {
    int insert_index=KeyIndex(key,comparator);
    IncreaseSize(1);
    for(int i=GetSize();i>=insert_index+1;i--)
    {
        array_[i]=array_[i-1];
    }
    array_[insert_index]={key,value};
    return GetSize();
}

/*****************************************************************************
 * ����
 *****************************************************************************/
/**
 *�������ܣ�
 * �ƶ�this�����һ�루����ȡ������Ԫ�ص�һ�������ɵ�recipient�����
 *���飺
 *  1.����ʵ��CopyNFrom����
 *  2.���ڲ�����CopyNFrom����ʵ�ָù���
 *  3.����this����recipient����NextPageId���ԣ�ע��recipient�����Ȼ��this����̽��
 *  eg:
 *      this == r1,  recipient == r2
 *      r1->[<0, r0>, <1, r1>, <2, r2>, <3, r3>, <4, r4>] ----MoveHalfTo--> r2[]
 *      result: r1->[<0, r0>, <1, r1>] ---> r2[<2, r2>, <3, r3>, <4, r4>]
 */
INDEX_TEMPLATE_ARGUMENTS
void B_PLUS_TREE_LEAF_PAGE_TYPE::MoveHalfTo(BPlusTreeLeafPage *recipient,
                                            __attribute__((unused)) BufferPoolManager *buffer_pool_manager) {

    printf("MoveHalfTo\n");
    int size=GetSize();
    int move_size=(size+1)>>1;
    recipient->CopyNFrom(array_+size/2,move_size);
    recipient->SetNExtPageId(GetNextPageId());
    SetNextPageId(recipient->GetPageId());
    SetSize(size-move_size);
    return ;                                        
}

/**
 * �������ܣ���item����ʼ����ȡsize����ֵ�Բ��뵽����β��
 * ���飺
 *  1.����size��С
 */
INDEX_TEMPLATE_ARGUMENTS
void B_PLUS_TREE_LEAF_PAGE_TYPE::CopyNFrom(MappingType *items, int size) {
    printf("CopyNFrom\n");
    MappingType* temp=items;
    for(int i=GetSize()+0;i<GetSize()+size;i++)
    {
        array_[i]=*temp;
        temp++;
    }
    IncreaseSize(size);
}

/*****************************************************************************
 * ����
 *****************************************************************************/
/**
 * �������ܣ�
 *  ��keyֵ�������е������У��ҵ��ض�keyֵ��Ӧ��value
 * ���飺
 *  1.���Ե���KeyIndex()����
 *  2.���keyֵ���ڣ��洢key��Ӧ��valueֵ������true
 *  3.���keyֵ�����ڣ�ֱ�ӷ���false
 *  4.ʹ��comparator����keyֵ�ıȽ�
 */
INDEX_TEMPLATE_ARGUMENTS
bool B_PLUS_TREE_LEAF_PAGE_TYPE::Lookup(const KeyType &key, ValueType *value, const KeyComparator &comparator) const {
    printf("LookUp\n");
    int index=KeyIndex(key,comparator);
    /*key not exist in this node*/
    if(index>=GetSize()||comparator(key,array_[index].first)!=0)
        return false;
    *value=array_[index].second;
    return true;


}

/*****************************************************************************
 * �Ƴ�
 *****************************************************************************/
/**
 * �������ܣ�
 *  1.�Ƴ�this����е�indexԪ��
 * ���飺
 *  1.��key������ʱ��ֱ�ӷ��ص�ǰsize
 *  1.ע��Ԫ�ص��ƶ�
 *  2.���²�����size
 */
INDEX_TEMPLATE_ARGUMENTS
int B_PLUS_TREE_LEAF_PAGE_TYPE::RemoveAndDeleteRecord(const KeyType &key, const KeyComparator &comparator) {
    printf("RemoveAndDeleteRecord\n");
    int index=KeyIndex(key,comparator);
    /*��key������*/
    if(index>=GetSize()||comparator(key,array_[index].first)!=0)
        return GetSize();
    for(int i=index;i<GetSize()-1;i++)
    {
        array_[j]=array_[j+1];
    }
    IncreaseSize(-1);
    return GetSize();
}

/*****************************************************************************
 * �ϲ�
 *****************************************************************************/
/**
 * �������ܣ�
 *  �ϲ�this����Ԫ����recipient����У�����this����е�ȫ��Ԫ������recipient����β��
 * ���飺
 *  1.this�����Ȼ��recipient�����Ҷ��㣬�����Ҫ����recipient����NextPageIdΪthis
 *     ����nextPageId��
 *  2.����size��С
 *  3.this�������ȫ���ƶ���sibling recipient��㣬��this���ĸ��ڵ�������Ҫɾ����������
 *    �ڱ�������ʵ�֡�
 */
INDEX_TEMPLATE_ARGUMENTS
void B_PLUS_TREE_LEAF_PAGE_TYPE::MoveAllTo(BPlusTreeLeafPage *recipient, BufferPoolManager *buffer_pool_manager) { 





}

/*****************************************************************************
 * �ط���
 *****************************************************************************/
/**
 * �������ܣ�
 *  �ƶ�this������Ԫ����recipient����ĩβ
 * ���飺
 *  1.recipient����CopyLastFrom����ʵ�ֽڵ����
 *  2.this������size
 *  3.����this�����Ԫ�ط����仯����˸������this��������keyֵ��Ҫ����
 */
INDEX_TEMPLATE_ARGUMENTS
void B_PLUS_TREE_LEAF_PAGE_TYPE::MoveFirstToEndOf(BPlusTreeLeafPage *recipient,
                                                  BufferPoolManager *buffer_pool_manager) {








}

/**
 * �������ܣ�
 *  ��pairԪ����ӵ�this����β��
 * ���飺
 *  1.����size
 */
INDEX_TEMPLATE_ARGUMENTS
void B_PLUS_TREE_LEAF_PAGE_TYPE::CopyLastFrom(const MappingType &item) {



}

/**
 * �������ܣ�
 *  �ƶ�this����β��Ԫ����recipient����ͷ��
 * ���飺
 *  1.recipient����CopyFirstFrom����ʵ�ֽڵ����
 *  2.this������size
 */
INDEX_TEMPLATE_ARGUMENTS
void B_PLUS_TREE_LEAF_PAGE_TYPE::MoveLastToFrontOf(BPlusTreeLeafPage *recipient,
                                                   BufferPoolManager *buffer_pool_manager) {



}

/**
 * �������ܣ�
 *  �ƶ�pairԪ����recipient�����ײ�
 * ���飺
 *  1.���ڽ����Ԫ�ط����仯���������this��������keyֵ��Ҫ����
 *  2.����size
 */
INDEX_TEMPLATE_ARGUMENTS
void B_PLUS_TREE_LEAF_PAGE_TYPE::CopyFirstFrom(const MappingType &item,
                                                BufferPoolManager *buffer_pool_manager) {



}

template class BPlusTreeLeafPage<GenericKey<4>, RID, GenericComparator<4>>;
template class BPlusTreeLeafPage<GenericKey<8>, RID, GenericComparator<8>>;
template class BPlusTreeLeafPage<GenericKey<16>, RID, GenericComparator<16>>;
template class BPlusTreeLeafPage<GenericKey<32>, RID, GenericComparator<32>>;
template class BPlusTreeLeafPage<GenericKey<64>, RID, GenericComparator<64>>;
}  // namespace bustub
