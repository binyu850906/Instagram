//
//  IGUser.swift
//  Instagram
//
//  Created by binyu on 2021/1/6.
//

import Foundation

struct IGUser: Codable{
    let graphql: Graphql
    struct Graphql: Codable {
        let user: User
        struct User: Codable {
            let biography: String
            let profile_pic_url_hd: URL
            let username: String
            let full_name: String
            let edge_followed_by: Edge_followed_by
            struct Edge_followed_by:Codable {
                let count: Int
            }
            let edge_owner_to_timeline_media: Edge_owner_to_timeline_media
            struct Edge_owner_to_timeline_media: Codable {
                let count: Int
                let edges: [Edges]
                struct Edges: Codable {
                    var node: Node
                    struct Node: Codable {
                        let display_url: URL
                        let edge_media_to_caption: Edge_media_to_caption
                        struct Edge_media_to_caption: Codable {
                            let edges: [Edges]
                            struct Edges: Codable {
                                var node: Node
                                struct Node: Codable {
                                    var text: String
                                }
                            }
                        }
                        let edge_media_to_comment: Edge_media_to_comment
                        struct Edge_media_to_comment: Codable {
                            let count: Int
                        }
                        let edge_liked_by: Edge_liked_by
                        struct Edge_liked_by: Codable {
                            let count: Int
                        }
                        let taken_at_timestamp: Date
                    }
                }
            }
            let edge_felix_video_timeline: Edge_felix_video_timeline
            struct Edge_felix_video_timeline: Codable {
                let edges: [Edges]
                struct Edges: Codable {
                    var node: Node
                    struct Node: Codable {
                        let display_url: URL
                        let video_url: URL
                    }
                }
            }
            let edge_follow: Edge_follow
            struct Edge_follow: Codable {
                let count: Int
            }
        }
    }
}
