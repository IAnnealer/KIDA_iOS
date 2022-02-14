//
//  PersistentStorage.swift
//  KIDA
//
//  Created by Ian on 2022/01/18.
//

import UIKit
import CoreData

final class PersistentStorage {

    // MARK: - Properties
    private let keywordList = ["100만원", "100퍼센트", "1박2일", "1퍼센트", "MBTI", "MT", "OTT", "e북", "n행시", "tv", "usb", "가위", "가을", "가족", "간식", "간직", "감", "감사", "감성", "강아지", "강원도", "강점혁명", "갤럭시", "거북이", "거실", "거울", "거주지", "거치대", "건강", "게스트하우스", "게임", "겨울", "결과", "경제", "경험", "계", "계단", "계절", "계획", "고구마", "고기", "고난", "고든 램지", "고양이", "고통", "골프", "곰표맥주", "곱창", "공간", "공구", "공부", "공연", "과거", "과일", "과자", "과제", "과학", "광어", "광어회", "광주", "교육", "구독", "국내여행", "귀마개", "귤", "그림", "그림자", "극복", "금융", "기계", "기네스", "기념일", "기술", "기적", "기차", "기타", "꽃", "꿈", "날개", "날씨", "낮잠", "네일", "넷플릭스", "노래", "노래방", "노트북", "눈", "눈물", "뉴욕", "능력", "니트", "다시", "다음 생", "다이어리", "다이어트 콜라", "단점", "달력", "달리기", "닭가슴살", "담배", "대통령", "덮밥", "데스크탑", "도서", "도시", "도시락", "도장깨기", "도전", "독서", "돈", "동물", "동아리", "동전", "드라마", "디저트", "디즈니", "디카페인", "딸기", "땅", "떡볶이", "라떼", "라면", "라운지", "렌즈", "로또당첨", "롤모델", "롱패딩", "리모콘", "립밤", "립스틱", "마법사", "마블", "마술", "마스크", "마우스", "만족", "만화", "맛집", "매너", "맥북", "맥주", "머그컵", "머리끈", "머플러", "면접", "명함", "모임", "모자", "목도리", "묘비", "무선 이어폰", "문", "문학", "문화", "물건", "물고기", "물티슈", "미래", "미용실", "밀도", "바디크림", "바디프로필", "바라클라바", "바베큐", "바지", "반려동물", "반려식물", "발명품", "발전", "발표", "밥솥", "방어회", "방울토마토", "방황", "배", "배달", "배터리", "버릇", "범고래", "벗꽃", "베개", "변화", "보물", "보조제", "볼펜", "봄", "부모님", "부산", "부엌", "분석", "뷔페", "블로그", "블록딜", "비", "비교", "비니", "비둘기", "비트코인", "비행기", "빨대", "빨래", "사과", "사랑", "사물함", "사원증", "사이다", "사이드 잡", "사이드 프로젝트", "사주", "사진", "사회", "산타클로스", "삶", "삼겹살", "삼행시", "새우깡", "색깔", "생각", "생명", "생일", "생활", "서랍", "서울", "서핑", "선물", "선풍기", "성격", "성과", "성취", "성형수술", "소주", "소중함", "소확행", "손가락", "쇼퍼백", "쇼핑", "쇼핑몰", "숏패딩", "수영장", "숙박", "술", "숨겨진 비밀", "스우파", "스키장", "스파게티", "스피커", "슬픔", "습관", "시기", "시니어", "시대", "시술", "시작", "식단", "식물", "신", "신념", "신발", "신점", "실현", "싫어하는 것", "싱크대", "아빠", "아이러니", "아이패드", "아이폰", "아침", "안약", "안주", "알잘딱깔센", "애완동물", "애인", "야식", "약", "양꼬치", "양말", "양식", "양심", "어린 시절", "어묵", "어제", "어쩔티비", "어플", "엄마", "업비트", "에어비엔비", "에어컨", "에어팟", "에어프라이어", "여름", "여의도", "여자친구", "남자친구", "여행", "연락", "연말", "연애", "연예인", "연차", "연초", "열정", "염색", "엽떡", "영상", "영화", "오늘", "오마카세", "오만", "옳고그름", "옷", "와이파이", "와인", "왓챠", "요리", "요술 램프", "용기", "우럭", "운동", "운동복", "운동장", "운동화", "운명", "웨이트", "웹툰", "유리", "유산소", "유종의 미", "유투브", "유튜브", "은행", "음식", "음악", "이불", "이사", "이상형", "이슈", "이어폰", "이직", "인상", "인스타", "인테리어", "일", "일기", "일상", "일식", "일주일", "일회용품", "자기 개발", "자기 계발", "자동차", "자리", "자서전", "자신", "자전거", "자취", "작업실", "잠", "잠실", "장갑", "장점", "저녁", "전기장판", "전력질주", "전시회", "전자기기", "전자담배", "전주", "전투", "절차", "점심", "점심 메뉴", "접시", "정거장", "정치", "제주도", "조명", "조언", "족발", "좋아하는 것", "좌우명", "주니어", "주말", "주방", "주식", "주제", "죽음", "중식", "지갑", "지구", "직업", "질투", "집", "집게", "집들이", "집사", "집중", "짜파게티", "참새", "참치", "창문", "책", "철학", "첫 눈", "청춘", "초밥", "축제", "충전기", "취미", "취준", "취향", "치킨", "친구", "침대", "칭따오", "칭찬", "카드", "카스", "카페", "캐리어", "캔들", "커리어", "커뮤니티", "커튼", "커피", "컨텐츠", "컴퓨터", "케이크", "코로나", "코트", "콘서트", "콜라", "쿠쿠루삥뽕", "타로", "탐험", "텀블러", "테니스", "테라", "테블릿", "투자", "특기", "티빙", "파트너", "판교", "패기", "패딩", "펜션", "편리함", "편지", "포장", "폴라로이드", "풍경", "프롤로그", "피땀눈물", "피시방", "피아노", "피자", "피트니스", "필통", "하늘", "하루", "하얼빈", "학교", "학습", "한강", "한식", "한우", "할많하않", "해산물", "해수욕장", "해외", "해외여행", "핸드폰", "햄버거", "행동", "행복", "향수", "헤드폰", "헬스", "현재", "협업", "협찬", "형제/자매", "호기심", "호캉스", "호텔", "홈카페", "화장실", "화장품", "활용", "회고", "회사", "회식", "휴가", "휴식", "휴일", "희노애락", "희망"]

    static let shared = PersistentStorage()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let entityName = KIDA_String.PersistentStorage.entityName

    /// 유저가 뽑은 키워드를 저장합니다.
    /// 해당 프로퍼티는 `pickKeyword()` 함수 호출을 통해 초기화 됩니다.
    var todayKeyword: String = ""

    // MARK: - Initializer
    private init() { pickKeyword() }

    // MARK: - API
    /// 로컬에 저장되어 있는 전체 일기 리스트를 반환합니다.
    func getAllDiary() -> [Diary] {
        var diaries: [Diary] = []
        do {
            diaries = try context.fetch(Diary.fetchRequest())
        } catch {
            print(error.localizedDescription)
            diaries = []
        }

        return diaries
    }

    /// 일기를 생성합니다.
    /// - Parameters:
    ///   - diary: 생성하고자 하는 일기 모델.
    ///   - onSuccess: 성공시 `true`를, 실패시 `false`를 반환합니다.
    func createDiary(_ diary: DiaryModel,
                     onSuccess: ((Bool) -> Void)? = nil) {

        guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: context) else {
            onSuccess?(false)
            return
        }

        let newDiary = Diary(entity: entity, insertInto: context)
        newDiary.content = diary.content
        newDiary.createdAt = diary.createdAt
        newDiary.keyword = diary.keyword
        newDiary.title = diary.title

        do {
            try context.save()
            onSuccess?(true)
        } catch {
            print(error.localizedDescription)
            onSuccess?(false)
        }
    }


    /// 일기를 삭제합니다.
    /// - Parameters:
    ///   - diary: 삭제하고자 하는 일기 모델.
    ///   - onSuccess: 성공시 `true`를, 실패시 `false`를 반환합니다.
    func deleteDiary(_ diary: Diary,
                     onSuccess: ((Bool) -> Void)? = nil) {
        context.delete(diary)

        do {
            try context.save()
            onSuccess?(true)
        } catch {
            print(error.localizedDescription)
            onSuccess?(false)
        }
    }


    /// 일기를 수정합니다.
    /// - Parameters:
    ///   - beforeDiary: 기존 일기 모델.
    ///   - afterDiary: 수정 이후 일기 모델.
    ///   - onSuccess: 성공시 `true`를, 실패시 `false`를 반환합니다.
    func updateDiary(before beforeDiary: inout DiaryModel,
                     after afterDiary: DiaryModel,
                     onSuccess: ((Bool) -> Void)? = nil) {
        beforeDiary = afterDiary

        do {
            try context.save()
            onSuccess?(true)
        } catch {
            print(error.localizedDescription)
            onSuccess?(false)
        }
    }


    /// 오늘의 키워드를 뽑아 반환합니다.
    /// 해당 키워드는 `PersistentStorage.shared.todaykeyword` 프로퍼티를 통해 확인할 수 있습니다.
    /// - Returns: 오늘의 키워드.
    @discardableResult
    func pickKeyword() -> String {
        todayKeyword = keywordList[Int.random(in: 0..<keywordList.count)]
        return todayKeyword
    }
    
    /// 오늘 일기를 썼는지 여부를 반환합니다.
    /// - Returns: 오늘 일기를 작성했으면 `true`를, 아니면 `false` 를 반환합니다.
    @discardableResult
    func isTodayWritten() -> Bool {
        var isWritten: Bool = false
        
        var diaries: [Diary] = []
        do {
            diaries = try context.fetch(Diary.fetchRequest())
        } catch {
            print(error.localizedDescription)
            diaries = []
        }
        
        for diary in diaries {
            if diary.createdAt?.toStringTypeOne == Date().toStringTypeOne {
                isWritten = true
            }
        }
        
        return isWritten
    }
    
}
